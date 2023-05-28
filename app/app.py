from flask import Flask, render_template, request, redirect, url_for
from planning import Data
import re

app = Flask(__name__)
data = ""

@app.route('/')
def hello():
    return render_template("index.html")

@app.route('/upload', methods=['POST'])
def upload_file():
    global data

    uploaded_file = request.files['file']
    
    if uploaded_file.filename.endswith('.txt'):
        file_contents = uploaded_file.read().decode('utf-8')

        return ""
    else:
        return render_template('index.html')
    
@app.route('/result')
def result():
    return render_template('result.html')


def parser_data(data):
    data = re.findall("[\d]+", data)
    n = int(data[0])
    min_ = int(data[1])
    max_ = int(data[2])
    i=1
    data_aux = data[3:]
    values = []

    while True:
        values.append(data_aux[n*(i-1):n*i])
        i+=1
        if i > n:
            break

    values = [[int(x) for x in row] for row in values]
    ob_model = Data(n, min_, max_, values)
    sol = ob_model.get_solution()

    return sol['Cal']

def organize(cal):
    list_dates = []
    num_date = 1

    for date in cal:
        i = 1
        for team in date:
            if team < 0:
                list_dates.append([f"Equipo {abs(team)}", f"Equipo {i}", f"Ronda {num_date}"])
            i+=1
        num_date+=1
    return list_dates
        

if __name__ == '__main__':
    app.run(debug=True)
