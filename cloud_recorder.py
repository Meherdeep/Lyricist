import requests
import time
TIMEOUT=60

#TODO: Fill in AppId, Basic Auth string, Cname (channel name), and cloud storage information
APPID=""
Auth=""
Cname="test"
ACCESS_KEY=""
SECRET_KEY=""
VENDOR = 1
REGION = 14
BUCKET = "agora-lyrist"

url="https://api.agora.io/v1/apps/%s/cloud_recording/" % APPID

acquire_body={
        "uid": "123",
        "cname": Cname,
        "clientRequest": {}
        }

#Set up two regions for two users
layoutConfig = [{"x_axis": 0.0, "y_axis": 0.0, "width": 0.3, "height": 0.3, "alpha": 0.9, "render_mode": 1},
                {"x_axis": 0.3, "y_axis": 0.0, "width": 0.3,"height": 0.3, "alpha": 0.77, "render_mode": 0}]
start_body={
        "uid": "123",
        "cname": Cname,
        "clientRequest": {
            "storageConfig": {
                "secretKey": SECRET_KEY,
                "region": REGION,
                "accessKey": ACCESS_KEY,
                "bucket": BUCKET,
                "vendor": VENDOR,
                "fileNamePrefix": [
                    "final"
                ]
                },
            "recordingConfig": {
                "audioProfile": 0,
                "channelType": 0,
                "maxIdleTime": 30,
                "streamTypes": 0,
                }
            }
        }

update_body = {
        "uid": "123",
        "cname": Cname,
        "clientRequest":{
            "mixedVideoLayout": 3,
            "backgroundColor": "#ff00cc",
            "layoutConfig":layoutConfig
        }
}
stop_body={
        "uid": "123",
        "cname": Cname,
        "clientRequest": {}
        }


def cloud_post(url, data=None,timeout=TIMEOUT):
    headers = {'Content-type': "application/json", "Authorization": Auth}

    try:
        response = requests.post(url, json=data, headers=headers, timeout=timeout, verify=False)
        print("url: %s, request body:%s response: %s" %(url, response.request.body,response.json()))
        return response
    except requests.exceptions.ConnectTimeout:
        raise Exception("CONNECTION_TIMEOUT")
    except requests.exceptions.ConnectionError:
        raise Exception("CONNECTION_ERROR")

def cloud_get(url, timeout=TIMEOUT):
    headers = {'Content-type':"application/json", "Authorization":Auth}
    try:
        response = requests.get(url, headers=headers, timeout=timeout, verify=False)
        print("url: %s,request:%s response: %s" %(url,response.request.body, response.json()))
        return response
    except requests.exceptions.ConnectTimeout:
        raise Exception("CONNECTION_TIMEOUT")
    except requests.exceptions.ConnectionError:
        raise Exception("CONNECTION_ERROR")

def start_record():
    acquire_url = url+"acquire"
    r_acquire = cloud_post(acquire_url, acquire_body)
    if r_acquire.status_code == 200:
        resourceId = r_acquire.json()["resourceId"]
    else:
        print("Acquire error! Code: %s Info: %s" %(r_acquire.status_code, r_acquire.json()))
        return False
    print("\n\n\n\n")

    start_url = url+ "resourceid/%s/mode/mix/start" % resourceId
    r_start = cloud_post(start_url, start_body)
    if r_start.status_code == 200:
        sid = r_start.json()["sid"]
    else:
        print("Start error! Code:%s Info:%s" %(r_start.status_code, r_start.json()))
        return False
    print("\n\n\n\n")

    time.sleep(30)
    query_url = url + "resourceid/%s/sid/%s/mode/mix/query" %(resourceId, sid)
    r_query = cloud_get(query_url)
    if r_query.status_code == 200:
        print("The recording status: %s" % r_query.json())
    else:
        print("Query failed. Code %s, info: %s" % (r_query.status_code, r_query.json()))

    time.sleep(10)

    print("\n\n\n\n")

    stop_url = url+"resourceid/%s/sid/%s/mode/mix/stop" % (resourceId, sid)
    r_stop = cloud_post(stop_url, stop_body)
    if r_stop.status_code == 200:
        print("Stop cloud recording success. FileList : %s, uploading status: %s"
            %(r_stop.json()["serverResponse"]["fileList"], r_stop.json()["serverResponse"]["uploadingStatus"]))
    else:
        print("Stop failed! Code: %s Info: %s" % r_stop.status_code, r_stop.json())

start_record()