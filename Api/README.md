Fashionpedia Api Github:
https://github.com/KMnP/fashionpedia-api/tree/master?tab=readme-ov-file

To Setup Virtual Envirnoment:
    (in Api folder run following commands in order)

$ python3 -m venv env
$ source env/bin/activate
$ pip install numpy
$ pip install 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'
$ pip install fashionpedia
$ pip install flask
(Download annotations.json)
$ curl https://s3.amazonaws.com/ifashionist-dataset/annotations/instances_attributes_train2020.json > annotations.json

To Run Api Locally:

$ python app.py

To Run Api For Remote Access

After app.py is running, run following command in a separate terminal
$ ngrok http 5002
    - port is configured in main of app.py
Visit the "Web Interface" address listed by ngrok (likely http://127.0.0.1:4040)
    There you can see the forwarding address to send requests to


Images Endpoint:
    /images/{number of images}
To send categories to filter by, send query parameters with value=category
    /images/{number of images}?category={category 1}&category={category 2}