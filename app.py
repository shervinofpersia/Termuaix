from flask import Flask, render_template, request, jsonify
import requests

app = Flask(__name__)

@app.route('/')
def index():
    # بارگذاری صفحه گرافیکی
    return render_template('index.html')

@app.route('/chat', methods=['POST'])
def chat():
    user_message = request.json.get('message')
    if not user_message:
        return jsonify({"error": "پیامی دریافت نشد."}), 400
    
    try:
        # ارسال مستقیم متن به درگاه Pollinations
        url = f"https://text.pollinations.ai/{user_message}"
        response = requests.get(url)
        return jsonify({"response": response.text})
    except Exception as e:
        return jsonify({"error": "خطا در ارتباط با سرور هوش مصنوعی"}), 500

if __name__ == '__main__':
    # اجرا روی لوکال‌هاست ترموکس
    app.run(host='127.0.0.1', port=5000)
