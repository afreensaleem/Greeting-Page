<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="helper.FlaskClient" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Our Anniversary</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Audiowide&family=Playwrite+US+Trad:wght@100..400&display=swap" rel="stylesheet">

<%
String name = "";
String tagline = "";
String base64Image = "";
String fileType = "";
String bgRemovedBase64 = "";

DiskFileItemFactory factory = new DiskFileItemFactory();
ServletFileUpload upload = new ServletFileUpload(factory);

try {
    List<FileItem> items = upload.parseRequest(request);
    for (FileItem item : items) {
        if (item.isFormField()) {
            if ("name1".equals(item.getFieldName())) {
                name = item.getString();
            } else if ("name2".equals(item.getFieldName())) {
                tagline = item.getString();
            } 
        } else {
            String fieldName = item.getFieldName();

            if ("mainImage".equals(fieldName)) {
                // Process the main display image
                fileType = item.getContentType();
                InputStream inputStream = item.getInputStream();
                byte[] bytes = IOUtils.toByteArray(inputStream);
                base64Image = Base64.getEncoder().encodeToString(bytes);
            } else if ("file".equals(fieldName)) {
                // Process the image for background removal
                InputStream inputStream = item.getInputStream();
                byte[] bytes = IOUtils.toByteArray(inputStream);

                try {
                    bgRemovedBase64 = FlaskClient.sendImageToFlask(new ByteArrayInputStream(bytes));
                } catch (Exception e) {
                    out.println("Error calling Flask API: " + e.getMessage());
                }
            }
        }
    }
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<style>
/* --- FONTS --- */
.audiowide-regular { font-family: "Audiowide", sans-serif; font-weight:400; font-size:30px; }
.anton-sc-regular { font-family:"Anton SC", sans-serif; font-weight:400; }
.playwrite-us-trad-cursive { font-family:"Playwrite US Trad", cursive; font-weight:100; }

/* --- BODY AND SECTION --- */
body { position:relative; background-color:#e3d5ca; }
section { position:relative; height:300px; width:100%; text-align:center; color:#f08080; padding:20px; background-color:#ffc2d1; box-shadow:0 5px 15px rgba(0,0,0,0.1); animation:fade-up 0.8s; }

/* --- IMAGE STYLING --- */
#img1{position:absolute; left:50%; top:50%; width:200px; height:270px; transform:translate(-50%,-50%) scale(0.8); border:3px solid #fff; opacity:0.88; z-index:1;}
#img2{z-index:3; height:370px; width:280px; animation:fade-in 2s;}
#img10{padding-left:40px; padding-bottom:20px; height:170px; width:130px;}
#img22{height:120px; width:120px; padding-left:10px; position:absolute;}

/* --- FRAME --- */
.frame{position:absolute; left:50%; top:50%; transform:translate(-45%,-3%); width:180px; height:250px; background:#d4d7dd; border:30px solid #fff; box-shadow:0 0 21px 3px rgba(0,0,0,0.5) inset, 0 15px 54px 10px rgba(0,0,0,0.3); padding:16px; border-radius:12px; transform:rotate(7deg); animation:fade-down 0.8s; z-index:4; }

/* --- ANIMATIONS --- */
@keyframes fade-up { 0%{opacity:0; transform:translateY(20px) scale(0.8);} 100%{opacity:1; transform:translateY(0px) scale(1);} }
@keyframes fade-down { 0%{opacity:0; transform:rotate(0deg) scale(0.9);} 100%{opacity:1; transform:rotate(7deg) scale(1);} }
@keyframes fade-in { 0%{opacity:0; height:320px; width:150px;} 100%{opacity:1; height:370px; width:290px;} }
@keyframes upDown { 0%{transform:translateY(0);} 50%{transform:translateY(-30px);} 100%{transform:translateY(0);} }

#heart{animation:upDown 2s infinite ease-in-out; margin:-70px; height:170px; width:100px; padding-left:100px; position:relative;}
.fontclass{margin:5px; padding-top:60px; padding-left:60px; font-family:sans-serif; font-size:55px; font-weight:bold; position:absolute; color:#e3d5ca; text-shadow:0.025em 0.025em 0 yellow,0.05em 0.05em 0 blue,0.075em 0.075em 0 red,0.1em 0.1em 0 black;}

/* --- BLOCKS --- */
.view{display:inline-flex; flex-wrap:wrap; margin:20px; padding:30px; justify-content:space-between;}
.block{border:3px solid #fff; height:200px; width:300px; background-color:#ffe5ec; border-radius:12px; margin:30px 10px; box-shadow:5px 10px #888888; outline:2px dashed #888888; outline-offset:-10px;}
.block.b1{position:relative; background-image:url(bg.png);}
.block.b2{position:relative;}
.block.b3{position:relative;}
.block.b4{position:relative;}

/* --- KEYFRAME EXAMPLES --- */
@keyframes appear { from{opacity:0; transform:translateX(-100px);} to{opacity:1; transform:translateX(0px);} }
.block{animation:appear linear; animation-timeline:view(); animation-range:entry 0% cover 40%;}
#beediv{position:relative; animation-name:example; animation-duration:3s; animation-delay:-1s; animation-iteration-count:150;}
@keyframes example {0%{transform:rotate(0deg); left:0; top:0;} 25%{left:3px; top:2px;} 50%{left:0; top:0;} 75%{left:3px; top:2px;} 100%{left:0; top:0;}}
#bee1div{position:relative; animation-name:example1; animation-duration:1s; animation-delay:-1s; animation-iteration-count:250;}
@keyframes example1{0%{left:0;top:0;} 25%{top:8px;} 50%{top:0;} 75%{top:8px;} 100%{top:0;}}

/* --- NAV AND FLOWERS --- */
#navdiv{position:absolute; left:-30px; top:-20px;}
#another-nav{position:absolute; left:-20px; top:20px; transform:scaleX(-1);}
#insidediv{padding-top:-20px; top:-20px; left:199px; position:absolute;}
</style>
</head>

<body>

<section id="top">
  <div id="navdiv">
    <img id="img22" style="height:250px;width:250px;" src="flower-12.png">
  </div>
  <div id="another-nav">
    <img id="3" style="height:300px;width:500px;" src="3flwr.png">
  </div>
     
  <h1 class="anton-sc-regular">Hello <%= name %></h1>
  <h2 class="playwrite-us-trad-cursive">My beloved, You are the epitome of beauty inside out</h2>

  <div class="frame">
      <% if (!base64Image.isEmpty()) { %>
          <img id="img1" src="data:<%= fileType %>;base64,<%= base64Image %>" />
      <% } else { %>
          <p>No image uploaded.</p>
      <% } %>
  </div>

  <div id="flower">
      <img id="img2" src="flowers.png" alt="flowers">
  </div>
</section>

<div class="view">
  <div class="block b1">
      <center>
          <h2 class="fontclass">U & I</h2>
          <div id="insidediv">
              <img id="img22" src="flower-12.png">
          </div>
      </center>
  </div>
  <div class="block b1" style="background-image:url(bg.png);"></div>
  <div class="block b1" style="background-image:url(bg2.png); background-size:310px 200px;"></div>

  <div class="block b2">
      <center><h2 class="playwrite-us-trad-cursive" style="color:#D2A82A;font-size:39px;padding-top:25px;">&#8592;belong&#8594;</h2></center>
  </div>

  <div class="block b2">
      <img style="height:260px;width:190px;position:absolute;padding-bottom:20px;transform:rotate(27deg);z-index:1" src="twig.png">
      <img style="height:90px;width:92px;position:absolute;padding-top:100px" src="crocus.png">
      <img id="img22" style="height:" src="flower-12.png">
      <img style="height:260px;width:190px;position:absolute;padding-bottom:70px;transform:rotate(40deg);" src="twig.png">
      <img style="height:90px;width:92px;position:absolute;padding-top:60px;padding-left:70px" src="crocus.png">
      <img id="img22" style="padding-top:80px;padding-left:40px;z-index:-1" src="flower-12.png">
      <div id="bee1div"><img style='height:37px;width:47px;position:absolute;padding-left:220px;transform:rotate(13deg);' src="bee.png"/></div>
      <div id="beediv"><img style='height:40px;width:50px;position:absolute;padding-left:250px;transform:rotate(-9deg);' src="bee.png"/></div>
  </div>

  <div class="block b3"><h2 class="fontclass" style="padding-left:30px;"><center>Together</center></h2></div>

  <div class="block b2" style="border-start-end-radius:45px;border-end-start-radius: 45px;">
      <center><img id="heart" src="heart.gif"></center>
      <% if (!bgRemovedBase64.isEmpty()) { %>
          <img id="img10" src="data:image/png;base64,<%= bgRemovedBase64 %>" alt="Background Removed Image">
      <% } else { %>
          <img id="img10" src="kucchu.png" alt="Fallback Image">
      <% } %>
  </div>

  <div class="block b3" style="background-image:url(bg3.png); background-size:500px; opacity:80%;">
      <div id="bg_text">
          <h2 class="anton-sc-regular" style="color:beige;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;">
              you are my <br> happy place
          </h2>
      </div>
  </div>
  <div class="block b3" style="background-image:url(bg4.png); background-size:300px;"></div>

  <div class="block b4">
      <center>
          <h1 class="audiowide-regular" style="padding-top:30px;color:#BA8FDB; text-shadow:0.025em 0.025em 0 yellow,0.05em 0.05em 0 blue,0.075em 0.075em 0 red,0.1em 0.1em 0 black;">
              Happy Anniversary
          </h1>
      </center>
      <img style="height:78px;width:120px;position:absolute;padding-left:10px;padding-top:-40px;margin-top:-20px;margin-left:170px;" src="bee2.png"/>
  </div>

  <div class="block b4">
      <center>
          <div style="background-image:url(bg5.png); background-size:300px; font-family:fantasy;font-size:50px;padding-top:20px;background-repeat:no-repeat;">
              te amo esposo
          </div>
      </center>
  </div>

  <div class="block b4" style="background-image:url(page.jpeg); background-size:300px; background-repeat:no-repeat;"></div>
</div>

<div>
    <img style="padding-left:120px; translate:scaleY(-1); transform:rotate(22deg);" src="bee2.png"/>
</div>

</body>
</html>
