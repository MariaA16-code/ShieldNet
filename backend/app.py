from flask import Flask
from extensions import db
from flask_bcrypt import Bcrypt
from flask_cors import CORS
from dotenv import load_dotenv
from urllib.parse import quote_plus
from extensions import db, mail
import os

load_dotenv()

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
CORS(app)

# DB Config
password = quote_plus(os.getenv('DB_PASSWORD'))

app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"mysql+pymysql://{os.getenv('DB_USER')}:{password}"
    f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
)

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')

# Mail Config
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')

db.init_app(app)
bcrypt = Bcrypt(app)
mail.init_app(app)

@app.route('/')
def home():
    return {"message": "ShieldNet backend is running ✅"}

from models import Victim, Report, Evidence, Takedown, Harasser, Case

with app.app_context():
    db.create_all()
from routes import api
app.register_blueprint(api)  
if __name__ == '__main__':
    app.run(debug=True)