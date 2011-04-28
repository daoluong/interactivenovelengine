LoadFont("default", "resources\\fonts\\NanumGothicBold.ttf", 17);
LoadFont("japanese", "resources\\fonts\\\meiryo.ttc", 17);
GetFont("japanese").LineSpacing = 10;

LoadFont("menu", "resources\\fonts\\NanumGothicBold.ttf", 13);
GetFont("menu").TextEffect = 1

LoadFont("bigmenu", "resources\\fonts\\NanumGothicBold.ttf", 23);
GetFont("bigmenu").TextEffect = 1


LoadFont("smalldefault", "resources\\fonts\\NanumGothicBold.ttf", 12);

LoadFont("date", "resources\\fonts\\NanumMyeongjoBold.ttf", 13);
GetFont("date").LineSpacing = 13
GetFont("date").TextEffect = 1

LoadFont("state", "resources\\fonts\\NanumGothicBold.ttf", 12);
GetFont("state").LineSpacing = 5

LoadFont("calstate", "resources\\fonts\\NanumGothicBold.ttf", 11);
GetFont("calstate").LineSpacing = 7

--LoadFont("dialogue", "resources\\fonts\\meiryo.ttc", 17);
LoadFont("dialogue", "resources\\fonts\\NanumGothicBold.ttf", 17, "resources\\fonts\\NanumGothicBold.ttf", 10);
GetFont("dialogue").LineSpacing = 10;
GetFont("dialogue").TextEffect = 1;

LoadFont("small", "resources\\fonts\\NanumMyeongjoBold.ttf", 15);
GetFont("small").LineSpacing = 10;
GetFont("small").TextEffect = 0;

LoadFont("verysmall", "resources\\fonts\\NanumGothicBold.ttf", 8);
GetFont("verysmall").LineSpacing = 5

LoadFont("verylarge", "c:\\windows\\fonts\\meiryo.ttc", 78);
--LoadFont("verylarge", "resources\\fonts\\NanumMyeongjoBold.ttf", 48);
GetFont("verylarge").LineSpacing = 30;