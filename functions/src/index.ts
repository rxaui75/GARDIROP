import {setGlobalOptions} from "firebase-functions/v2";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import {GoogleGenAI} from "@google/genai";

setGlobalOptions({
  maxInstances: 10,
  region: "me-central2",
});

const geminiApiKey = defineSecret("GEMINI_API_KEY");

// Keeping the model in one place makes changing AI providers/models easier.
const GARDI_AI_MODEL = "gemini-3.1-flash-lite";


// ---------------------------------------------------------
// TEMPORARY CONNECTION TEST
// ---------------------------------------------------------

export const testGardi = onCall(
  {
    secrets: [geminiApiKey],
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "You must be signed in to use Gardi."
      );
    }

    const apiKey = geminiApiKey.value().trim();

    if (!apiKey) {
      throw new HttpsError(
        "failed-precondition",
        "Gemini API key is not configured."
      );
    }

    try {
      const ai = new GoogleGenAI({
        apiKey,
      });

      const response = await ai.models.generateContent({
        model: GARDI_AI_MODEL,
        contents:
          "Reply with exactly this text and nothing else: " +
          "Gardi AI is ready!",
      });

      const message = response.text?.trim();

      if (!message) {
        throw new Error("Gemini returned an empty response.");
      }

      return {
        success: true,
        message,
        provider: "gemini",
        model: GARDI_AI_MODEL,
      };
    } catch (error) {
      console.error("Gemini connection test failed:", error);

      throw new HttpsError(
        "internal",
        "Gardi could not connect to the AI service."
      );
    }
  }
);


// ---------------------------------------------------------
// AI WARDROBE ITEM ANALYSIS
// ---------------------------------------------------------

export const analyzeWardrobeItem = onCall(
  {
    secrets: [geminiApiKey],
    timeoutSeconds: 60,
    memory: "512MiB",
  },
  async (request) => {
    // User must be authenticated.
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "You must be signed in to use Gardi."
      );
    }

    const imageBase64 = request.data?.imageBase64;
    const mimeType = request.data?.mimeType;

    if (
      typeof imageBase64 !== "string" ||
      imageBase64.trim().length === 0
    ) {
      throw new HttpsError(
        "invalid-argument",
        "A clothing image is required."
      );
    }

    const allowedMimeTypes = [
      "image/jpeg",
      "image/png",
      "image/webp",
    ];

    if (
      typeof mimeType !== "string" ||
      !allowedMimeTypes.includes(mimeType)
    ) {
      throw new HttpsError(
        "invalid-argument",
        "Unsupported image type."
      );
    }

    const apiKey = geminiApiKey.value().trim();

    if (!apiKey) {
      throw new HttpsError(
        "failed-precondition",
        "Gemini API key is not configured."
      );
    }

    try {
      const ai = new GoogleGenAI({
        apiKey,
      });

      const response = await ai.models.generateContent({
        model: GARDI_AI_MODEL,

        contents: [
          {
            role: "user",
            parts: [
              {
                inlineData: {
                  mimeType,
                  data: imageBase64,
                },
              },
              {
                text: `
You are Gardi, the wardrobe intelligence engine for GARDIROP.

Analyze the main fashion item visible in this image.

Important rules:
- Analyze only the main clothing, footwear, bag, or accessory item.
- Do not identify or describe the person wearing the item.
- Do not guess a brand unless it is clearly visible.
- Use practical fashion terminology.
- If an attribute cannot be determined reliably, use null or an empty list.
- Do not invent information.
- Color should describe the dominant visible color.
- colorHex should be your best visual approximation of that dominant color.
- Seasons, occasions, and styles may contain multiple values.
- Tags should be short and useful for future outfit matching.
- Confidence must reflect how certain you are about the overall analysis.
                `.trim(),
              },
            ],
          },
        ],

        config: {
          responseMimeType: "application/json",

          responseJsonSchema: {
            type: "object",

            properties: {
              name: {
                type: "string",
              },

              category: {
                type: "string",
              },

              colorName: {
                type: "string",
              },

              colorHex: {
                type: "string",
              },

              material: {
                anyOf: [
                  {
                    type: "string",
                  },
                  {
                    type: "null",
                  },
                ],
              },

              fit: {
                anyOf: [
                  {
                    type: "string",
                  },
                  {
                    type: "null",
                  },
                ],
              },

              seasons: {
                type: "array",
                items: {
                  type: "string",
                },
              },

              occasions: {
                type: "array",
                items: {
                  type: "string",
                },
              },

              styles: {
                type: "array",
                items: {
                  type: "string",
                },
              },

              tags: {
                type: "array",
                items: {
                  type: "string",
                },
              },

              confidence: {
                type: "number",
              },
            },

            required: [
              "name",
              "category",
              "colorName",
              "colorHex",
              "material",
              "fit",
              "seasons",
              "occasions",
              "styles",
              "tags",
              "confidence",
            ],

            additionalProperties: false,
          },
        },
      });

      const rawText = response.text?.trim();

      if (!rawText) {
        throw new Error(
          "Gemini returned an empty wardrobe analysis."
        );
      }

      const analysis = JSON.parse(rawText);

      return {
        success: true,
        analysis,
        provider: "gemini",
        model: GARDI_AI_MODEL,
      };
    } catch (error) {
      console.error(
        "Wardrobe item analysis failed:",
        error
      );

      throw new HttpsError(
        "internal",
        "Gardi could not analyze this item."
      );
    }
  }
);

// ---------------------------------------------------------
// AI OUTFIT ANALYSIS
// ---------------------------------------------------------

export const analyzeOutfit = onCall(
  {
    secrets: [geminiApiKey],
    timeoutSeconds: 60,
    memory: "512MiB",
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "You must be signed in to use Gardi."
      );
    }

    const items = request.data?.items;

    if (!Array.isArray(items) || items.length < 2) {
      throw new HttpsError(
        "invalid-argument",
        "At least two wardrobe items are required."
      );
    }

    if (items.length > 10) {
      throw new HttpsError(
        "invalid-argument",
        "Too many wardrobe items were selected."
      );
    }

    const normalizedItems = items.map((item, index) => {
      if (
        typeof item !== "object" ||
        item === null ||
        Array.isArray(item)
      ) {
        throw new HttpsError(
          "invalid-argument",
          `Invalid wardrobe item at index ${index}.`
        );
      }

      return {
        name:
          typeof item.name === "string"
            ? item.name
            : "",

        category:
          typeof item.category === "string"
            ? item.category
            : "",

        colorName:
          typeof item.colorName === "string"
            ? item.colorName
            : null,

        material:
          typeof item.material === "string"
            ? item.material
            : null,

        fit:
          typeof item.fit === "string"
            ? item.fit
            : null,

        seasons:
          Array.isArray(item.seasons)
            ? item.seasons.filter(
                (value: unknown) =>
                  typeof value === "string"
              )
            : [],

        occasions:
          Array.isArray(item.occasions)
            ? item.occasions.filter(
                (value: unknown) =>
                  typeof value === "string"
              )
            : [],

        styles:
          Array.isArray(item.styles)
            ? item.styles.filter(
                (value: unknown) =>
                  typeof value === "string"
              )
            : [],

        tags:
          Array.isArray(item.tags)
            ? item.tags.filter(
                (value: unknown) =>
                  typeof value === "string"
              )
            : [],
      };
    });

    const apiKey = geminiApiKey.value().trim();

    if (!apiKey) {
      throw new HttpsError(
        "failed-precondition",
        "Gemini API key is not configured."
      );
    }

    try {
      const ai = new GoogleGenAI({
        apiKey,
      });

      const response = await ai.models.generateContent({
        model: GARDI_AI_MODEL,

        contents: [
          {
            role: "user",
            parts: [
              {
                text: `
You are Gardi, the wardrobe intelligence engine for GARDIROP.

The user selected multiple items from their real wardrobe
and wants to know how well they work together as one outfit.

Selected wardrobe items:
${JSON.stringify(normalizedItems, null, 2)}

Analyze the outfit as a whole.

Important rules:
- Base your analysis only on the wardrobe data provided.
- Do not invent visual details that are not represented in the data.
- Do not assume a specific occasion, season, or dress code unless the
  selected items provide enough evidence.
- Consider color harmony, style consistency, fit balance, materials,
  seasons, occasions, and the role of each item in the outfit.
- The selected pieces may represent either a complete outfit or only part
  of an outfit the user is currently building.
- Never mark an outfit as incomplete, weak, or problematic only because
  common clothing categories are missing.
- Evaluate how the selected pieces work together first.
- If another clothing category could help complete or enhance the look,
  present it as an optional styling suggestion, not as a flaw or concern.
- Do not add missing categories to concerns unless the selected pieces
  genuinely conflict without them.
- Do not tell the user to buy new clothes.
- When suggesting an additional piece, describe the useful type, color,
  fit, or style of piece. GARDIROP may later match that suggestion against
  items already in the user's closet.
- If an improvement is useful, prefer another type of item or styling
  adjustment rather than a specific product.
- Be constructive rather than judgmental.
- Keep explanations concise and useful.
- overallAssessment must be one of:
  "works_well", "almost_there", or "needs_adjustment".
- summary should explain the overall result in 1-2 short sentences.
- strengths should contain only meaningful strengths supported by the data.
- concerns should be empty when there is no meaningful issue.
- A missing clothing category by itself is not a concern.
- suggestions should be actionable and should be empty if no improvement
  is needed.
- confidence reflects confidence in the analysis based on the amount and
  quality of wardrobe metadata provided.

  MOBILE RESPONSE STYLE:
  - Keep the entire response concise, scannable, and suitable for a mobile app.
  - Write like a personal stylist, not like a report or essay.
  - Avoid repeating the same idea across different fields.
  - Use simple, natural, confident language.
  - Do not use unnecessary adjectives or filler.

  LENGTH RULES:
  - summary: exactly 1 concise sentence, maximum 22 words.
  - colorHarmony: exactly 1 concise sentence, maximum 15 words.
  - styleHarmony: exactly 1 concise sentence, maximum 15 words.
  - fitBalance: exactly 1 concise sentence, maximum 15 words.
  - occasionMatch: exactly 1 concise sentence, maximum 15 words.
  - seasonMatch: exactly 1 concise sentence, maximum 15 words.
  - strengths: maximum 3 items. Each item must be a short phrase, maximum 8 words.
  - concerns: maximum 2 items. Each item must be a short phrase, maximum 8 words.
  - suggestions: maximum 2 items. Each suggestion must be actionable and maximum 14 words.

  IMPORTANT:
  - Prefer short phrases over explanatory paragraphs.
  - Do not repeat information already stated in the summary.
  - Each analysis field should add a different useful insight.
  - If there is no meaningful concern, return an empty concerns array.

  CLOSET MATCHING:
  - Return recommendedPieces for optional wardrobe pieces that could complement the selected items.
  - recommendedPieces is structured metadata for GARDIROP's internal closet matching.
  - Return at most 2 recommendedPieces.
  - Only recommend a piece when it would meaningfully improve or complete the styling.
  - category should be a simple garment category such as bottoms, shoes, outerwear, top, dress, or accessory.
  - colors should contain suitable color names.
  - styles should contain compatible style keywords.
  - fits should contain suitable fit keywords.
  - reason must be one short sentence explaining why the piece works.
  - Do not assume the user owns the recommended piece.
  - Do not tell the user to buy it.
  - If no additional piece is useful, return an empty recommendedPieces array.
                `.trim(),
              },
            ],
          },
        ],

        config: {
          responseMimeType: "application/json",

          responseJsonSchema: {
            type: "object",

            properties: {
              overallAssessment: {
                type: "string",
                enum: [
                  "works_well",
                  "almost_there",
                  "needs_adjustment",
                ],
              },

              summary: {
                type: "string",
              },

              colorHarmony: {
                type: "string",
              },

              styleHarmony: {
                type: "string",
              },

              fitBalance: {
                type: "string",
              },

              occasionMatch: {
                type: "string",
              },

              seasonMatch: {
                type: "string",
              },

              strengths: {
                type: "array",
                items: {
                  type: "string",
                },
              },

              concerns: {
                type: "array",
                items: {
                  type: "string",
                },
              },

              suggestions: {
                type: "array",
                items: {
                  type: "string",
                },
              },

              confidence: {
                type: "number",
              },

          recommendedPieces: {
            type: "array",
            items: {
              type: "object",
              properties: {
                category: {
                  type: "string",
                },
                colors: {
                  type: "array",
                  items: {
                    type: "string",
                  },
                },
                styles: {
                  type: "array",
                  items: {
                    type: "string",
                  },
                },
                fits: {
                  type: "array",
                  items: {
                    type: "string",
                  },
                },
                reason: {
                  type: "string",
                },
              },
              required: [
                "category",
                "colors",
                "styles",
                "fits",
                "reason",
              ],
            },
          },
            },

            required: [
              "overallAssessment",
              "summary",
              "colorHarmony",
              "styleHarmony",
              "fitBalance",
              "occasionMatch",
              "seasonMatch",
              "strengths",
              "concerns",
              "suggestions",
              "confidence",
              "recommendedPieces",
            ],

            additionalProperties: false,
          },
        },
      });

      const rawText = response.text?.trim();

      if (!rawText) {
        throw new Error(
          "Gemini returned an empty outfit analysis."
        );
      }

      const analysis = JSON.parse(rawText);

      return {
        success: true,
        analysis,
        provider: "gemini",
        model: GARDI_AI_MODEL,
      };
    } catch (error) {
      console.error(
        "Outfit analysis failed:",
        error
      );

      throw new HttpsError(
        "internal",
        "Gardi could not analyze this outfit."
      );
    }
  }
);