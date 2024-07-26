from pywebgui import WebGui, Widget
from flask import Flask, render_template, request
app = Flask(__name__)
# Create a route for the form submission
@app.route('/form', methods=['GET', 'POST'])
def display_form():
    form_data = {}
    if request.method == 'POST':
        form_data = request.form
        # Send data to the next page using Flask's redirect() method or render_template()
        return redirect(os.environ.get('NEXT_PAGE'))
        # Replace os.environ.get('NEXT_PAGE') with the path to your template file


# Render the HTML template with PyWebGUI window
display_form.html(return_type='text', template_kwargs={'form_data': form_data})
