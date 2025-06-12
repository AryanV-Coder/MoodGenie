from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from gemini_handler import get_ai_response, summary_of_conversation

app = FastAPI()

# To allow your Flutter frontend to call this API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace with your frontend domain in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Model for request body
class PromptRequest(BaseModel):
    user_prompt: str

@app.post("/chat")
async def chat_with_moodgenie(request: PromptRequest):
    """
    This endpoint receives user input and returns the Gemini AI response.
    """
    user_text = request.user_prompt
    response = get_ai_response(user_text)
    return {"response": response}


@app.get("/summary")
async def get_summary():
    """
    This endpoint is called when the app closes to fetch a summary + quote/joke.
    """
    summary = summary_of_conversation()
    return {"summary": summary}
