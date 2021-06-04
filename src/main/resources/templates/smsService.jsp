<%@ page language="java" import="java.util.*, java.security.*, java.io.*, java.net.*" %>
<%!
    /**==============================================================
     Description        :  ��� �Լ� ����
     ==============================================================**/
    /**
     * nullcheck
     * @param str, Defaultvalue
     * @return
     */

    public static String nullcheck(String str,  String Defaultvalue ) throws Exception
    {
        String ReturnDefault = "" ;
        if (str == null)
        {
            ReturnDefault =  Defaultvalue ;
        }
        else if (str == "" )
        {
            ReturnDefault =  Defaultvalue ;
        }
        else
        {
            ReturnDefault = str ;
        }
        return ReturnDefault ;
    }
    /**
     * BASE64 Encoder
     * @param str
     * @return
     */
    public static String base64Encode(String str)  throws java.io.IOException {
        sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();
        byte[] strByte = str.getBytes();
        String result = encoder.encode(strByte);
        return result ;
    }

    /**
     * BASE64 Decoder
     * @param str
     * @return
     */
    public static String base64Decode(String str)  throws java.io.IOException {
        sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
        byte[] strByte = decoder.decodeBuffer(str);
        String result = new String(strByte);
        return result ;
    }
%>
<%
    /**==============================================================
     Description        : ĳ���ͼ� ����
     EUC-KR: @ page contentType="text/html;charset=EUC-KR
     UTF-8: @ page contentType="text/html;charset=UTF-8
     ==============================================================**/
%>
<%@ page contentType="text/html;charset=EUC-KR"%>
<%
    /**==============================================================
     Description        :  ����� �����ڵ�
     ==============================================================**/
    String charsetType = "EUC-KR"; //EUC-KR �Ǵ� UTF-8

    request.setCharacterEncoding(charsetType);
    response.setCharacterEncoding(charsetType);
    String  action     = nullcheck(request.getParameter("action"), "");
    if(action.equals("go")) {

        String sms_url = "";
        sms_url = "https://sslsms.cafe24.com/sms_sender.php"; // SMS ���ۿ�û URL
        String user_id = base64Encode("ajchoi9709"); // SMS���̵�
        String secure = base64Encode("31e2e5d46e1e2059449efe64cde0693d");   //����Ű �ʼ�
        String msg = base64Encode(nullcheck(request.getParameter("msg"), ""));
        String rphone = base64Encode(nullcheck(request.getParameter("rphone"), ""));
        String sphone1 = base64Encode(nullcheck(request.getParameter("sphone1"), ""));
        String sphone2 = base64Encode(nullcheck(request.getParameter("sphone2"), ""));
        String sphone3 = base64Encode(nullcheck(request.getParameter("sphone3"), ""));
        String rdate = base64Encode(nullcheck(request.getParameter("rdate"), ""));
        String rtime = base64Encode(nullcheck(request.getParameter("rtime"), ""));
        String mode = base64Encode("1");
        String subject = "";
        if(nullcheck(request.getParameter("smsType"), "").equals("L")) {
            subject = base64Encode(nullcheck(request.getParameter("subject"), ""));
        }
        String testflag = base64Encode(nullcheck(request.getParameter("testflag"), ""));
        String destination = base64Encode(nullcheck(request.getParameter("destination"), ""));
        String repeatFlag = base64Encode(nullcheck(request.getParameter("repeatFlag"), ""));
        String repeatNum = base64Encode(nullcheck(request.getParameter("repeatNum"), ""));
        String repeatTime = base64Encode(nullcheck(request.getParameter("repeatTime"), ""));
        String returnurl = nullcheck(request.getParameter("returnurl"), "");
        String nointeractive = nullcheck(request.getParameter("nointeractive"), "");
        String smsType = base64Encode(nullcheck(request.getParameter("smsType"), ""));

        String[] host_info = sms_url.split("/");
        String host = host_info[2];
        String path = "/" + host_info[3];
        int port = 80;

        // ������ ���� ���� ����
        String arrKey[]
                = new String[] {"user_id","secure","msg", "rphone","sphone1","sphone2","sphone3","rdate","rtime"
                ,"mode","testflag","destination","repeatFlag","repeatNum", "repeatTime", "smsType", "subject"};
        String valKey[]= new String[arrKey.length] ;
        valKey[0] = user_id;
        valKey[1] = secure;
        valKey[2] = msg;
        valKey[3] = rphone;
        valKey[4] = sphone1;
        valKey[5] = sphone2;
        valKey[6] = sphone3;
        valKey[7] = rdate;
        valKey[8] = rtime;
        valKey[9] = mode;
        valKey[10] = testflag;
        valKey[11] = destination;
        valKey[12] = repeatFlag;
        valKey[13] = repeatNum;
        valKey[14] = repeatTime;
        valKey[15] = smsType;
        valKey[16] = subject;

        String boundary = "";
        Random rnd = new Random();
        String rndKey = Integer.toString(rnd.nextInt(32000));
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] bytData = rndKey.getBytes();
        md.update(bytData);
        byte[] digest = md.digest();
        for(int i =0;i<digest.length;i++)
        {
            boundary = boundary + Integer.toHexString(digest[i] & 0xFF);
        }
        boundary = "---------------------"+boundary.substring(0,11);

        // ���� ����
        String data = "";
        String index = "";
        String value = "";
        for (int i=0;i<arrKey.length; i++)
        {
            index =  arrKey[i];
            value = valKey[i];
            data +="--"+boundary+"\r\n";
            data += "Content-Disposition: form-data; name=\""+index+"\"\r\n";
            data += "\r\n"+value+"\r\n";
            data +="--"+boundary+"\r\n";
        }

        //out.println(data);

        InetAddress addr = InetAddress.getByName(host);
        Socket socket = new Socket(host, port);
        // ��� ����
        BufferedWriter wr = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), charsetType));
        wr.write("POST "+path+" HTTP/1.0\r\n");
        wr.write("Content-Length: "+data.length()+"\r\n");
        wr.write("Content-type: multipart/form-data, boundary="+boundary+"\r\n");
        wr.write("\r\n");

        // ������ ����
        wr.write(data);
        wr.flush();

        // ����� ���
        BufferedReader rd = new BufferedReader(new InputStreamReader(socket.getInputStream(),charsetType));
        String line;
        String alert = "";
        ArrayList tmpArr = new ArrayList();
        while ((line = rd.readLine()) != null) {
            tmpArr.add(line);
        }
        wr.close();
        rd.close();

        String tmpMsg = (String)tmpArr.get(tmpArr.size()-1);
        String[] rMsg = tmpMsg.split(",");
        String Result= rMsg[0]; //�߼۰��
        String Count= ""; //�ܿ��Ǽ�
        if(rMsg.length>1) {Count= rMsg[1]; }

        //�߼۰�� �˸�
        if(Result.equals("success")) {
            alert = "���������� �߼��Ͽ����ϴ�.";
            alert += " �ܿ��Ǽ��� "+ Count+"�� �Դϴ�.";
        }
        else if(Result.equals("reserved")) {
            alert = "���������� ����Ǿ����ϴ�";
            alert += " �ܿ��Ǽ��� "+ Count+"�� �Դϴ�.";
        }
        else if(Result.equals("3205")) {
            alert = "�߸��� ��ȣ�����Դϴ�.";
        }
        else {
            alert = "[Error]"+Result;
        }

        out.println(nointeractive);

        if(nointeractive.equals("1") && !(Result.equals("Test Success!")) && !(Result.equals("success")) && !(Result.equals("reserved")) ) {
            out.println("<script>alert('" + alert + "')</script>");
        }
        else if(!(nointeractive.equals("1"))) {
            out.println("<script>alert('" + alert + "')</script>");
        }


        out.println("<script>location.href='"+returnurl+"';</script>");
    }
%>

