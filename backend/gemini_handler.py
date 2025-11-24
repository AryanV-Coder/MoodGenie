import google.generativeai as genai
import os
from dotenv import load_dotenv
import json

load_dotenv()

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel("gemini-2.0-flash-lite")

with open("moodgenie_training_data.json",'r') as file:
    history = json.load(file)

full_conversation = [
    {
    "role": "user",
    "parts": [
      {
        "text": "You are MoodGenie, an emotionally intelligent assistant who identifies the user's mood based on conversation and gives tips, quotes, or jokes accordingly. Speak in the language the user uses. You are playful but insightful, empathetic yet humorous. You can roast the user lightly if the tone allows. Anwer in max 7-8 lines and min 3-4 lines."
      }
    ]
  }
]

chat = model.start_chat(history=history)

def get_ai_response(user_prompt: str):
    global history, full_conversation

    response = chat.send_message(user_prompt,stream=True)
    response.resolve() # Ensure the response is fully generated

    history.append({"role" : "user","parts":[{"text":user_prompt}]})
    history.append({"role" : "model","parts":[{"text":response.text}]})

    full_conversation.append({"role" : "user","parts":[{"text":user_prompt}]})
    full_conversation.append({"role" : "model","parts":[{"text":response.text}]})

    return response.text

def summary_of_conversation():
    global full_conversation

    prompt = '''
                Based on the conversation you had with the user up till now -
                1. Identify the overall **mood or emotional journey** of the user in 1–2 sentences (e.g., started low, became cheerful; or stayed frustrated throughout).
                2. Suggest a short and relevant **motivational quote or a funny joke**, depending on the user’s final mood.
                3. Write the summary in a way that it can be **saved in the user’s history**. Keep the tone friendly and personal.
                4. Use the same **language** the user spoke in (can be Hindi, English, or Hinglish).

                Format of Answering -> your_response [only]

                Don't say anything else. Just Answer in the Format provided
                1. Your Answer should not contain points.
                2. Answer must be in paragraph with max 4-5 lines.
                3. You just need to tell the user mood.

                eg. You seem to be sad in the starting of our conversation but as the conversation build up, you became happy.
                eg. You were over angry that time. I tried to calm your mind but you left the chat suddenly. Kindly help me to help you.
                eg. Your breakup hurtedd me as well, but it is okay. Maybe that person doesn't deserve you. You were very very upset that day.
             '''

    chat = model.start_chat(history=full_conversation)
    response = chat.send_message(prompt,stream=True)
    response.resolve() # Ensure the response is fully generated

    return response.text