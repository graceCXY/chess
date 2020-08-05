import processing.net.*;
Client myclient;

final int pw = 1;
final int nw = 2;
final int bw = 3;
final int rw = 4;
final int qw = 5;
final int kw = 6;

final int pb = -1;
final int nb = -2;
final int bb = -3;
final int rb = -4;
final int qb = -5;
final int kb = -6;

final int empty = 0;
final int selected = 100;
int piecechosen = 0;
int promotedpawn = 0;
int kingcount = 0;

int mode;
final int start= 10;
final int playing = 20;
final int pawnpromotion = 30;
final int gameover = 40;

ArrayList<String> possiblemoves = new ArrayList<String>();

int[][] board = { 
  {rw, nw, bw, kw, qw, bw, nw, rw}, 
  {pw, pw, pw, pw, pw, pw, pw, pw}, 
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {pb, pb, pb, pb, pb, pb, pb, pb}, 
  {rb, nb, bb, kb, qb, bb, nb, rb}, 
};

PImage intro, gameoverscreen;

PImage pawnwhite;
PImage knightwhite;
PImage bishopwhite;
PImage rookwhite;
PImage queenwhite;
PImage kingwhite;

PImage pawnblack;
PImage knightblack;
PImage bishopblack;
PImage rookblack;
PImage queenblack;
PImage kingblack;

PImage chessboard;
PImage paw;

PImage imagechosen;
boolean secondclick;
boolean selecting;
boolean reset;
boolean canmove;
boolean validmove;

boolean leftedge = false;
boolean rightedge = false;
boolean downedge = false;

int pr;
int pc;
int er;
int ec;

void setup() {
  size(800, 800); 
  myclient = new Client(this, "127.0.0.1", 1234); 

  pawnwhite = loadImage("whitepawn.png");
  knightwhite= loadImage("whiteknight.png");
  bishopwhite= loadImage("whitebishop.png");
  rookwhite = loadImage("whiterook.png");
  queenwhite = loadImage("whitequeen.png");
  kingwhite = loadImage("whiteking.png");

  pawnblack = loadImage("blackpawn.png");
  knightblack= loadImage("blackknight.png");
  bishopblack= loadImage("blackbishop.png");
  rookblack = loadImage("blackrook.png");
  queenblack = loadImage("blackqueen.png");
  kingblack = loadImage("blackking.png");

  chessboard = loadImage("board.png");
  paw = loadImage("paw.png");

  intro = loadImage("introscreen.jpg");
  gameoverscreen = loadImage("gameoverscreen.jpg");


  secondclick = false;
  selecting = false;
  reset = false;
  canmove = false;

  validmove = false;

  mode = start;
}

void draw() {

  if (mode == start) {
    reset = true;
    imageMode(CORNER);
    image(intro, 0, 0, 800, 800);
    textAlign(CENTER, CENTER);
    textSize(100);
    fill(0, 0, 0);
    text("Chess", 400, 350);

    textSize(50);
    text("Click to start", 400, 450);

    if (reset == true) {
      board[0][0]= rw;
      board[0][1]= nw;
      board[0][2] = bw;
      board[0][3] = kw;
      board[0][4] = qw;
      board[0][5] = bw;
      board[0][6] = nw;
      board[0][7] = rw;

      for (int xw =0; xw<8; xw++) {
        board[1][xw] = pw;
      }

      for (int x =0; x<8; x++) {
        board[2][x] = empty;
      }
      for (int x =0; x<8; x++) {
        board[3][x] = empty;
      }
      for (int x =0; x<8; x++) {
        board[4][x] = empty;
      }
      for (int x =0; x<8; x++) {
        board[5][x] = empty;
      }
      for (int xb =0; xb<8; xb++) {
        board[6][xb] = pb;
      }

      board[7][0]= rb;
      board[7][1]= nb;
      board[7][2] = bb;
      board[7][3] = kb;
      board[7][4] = qb;
      board[7][5] = bb;
      board[7][6] = nb;
      board[7][7] = rb;

      reset = false;
    }
  } else if (mode == playing) {
    imageMode(CORNER);
    image(chessboard, 0, 0, 800, 800);

    int mr = 0;
        int mc = 0;
        kingcount = 0;
        while (mr < 8) {

          if (board[mr][mc] == kw ||board[mr][mc] == kb ) {
            kingcount++;
            //println("comeon" +kingcount);
          }
          mc++;
          if (mc >=8) {
            mr++;
            mc = 0;
          }
        }
        if (kingcount<2 && selecting == false) {
          //myclient.write("299"+","+"299"+ "," +"299"+ "," +"299"+ "," +"299");
          mode = gameover;
        }
        
    int r = 0; 
    int c = 0;

    while (r<8) {


      if (board[r][c] == empty) {
        noStroke();
        fill(255, 255, 255, 0);
        rect(c*100, r*100, 100, 100);
      } else if (board[r][c] == pw ) {
        image(pawnwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == rw) {
        image(rookwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == nw) {
        image(knightwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == bw) {
        image(bishopwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == qw) {
        image(queenwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == kw) {
        image(kingwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == pb ) {
        image(pawnblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == rb) {
        image(rookblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == nb) {
        image(knightblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == bb) {
        image(bishopblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == qb) {
        image(queenblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == kb) {
        image(kingblack, c*100, r*100, 100, 100);
      }
      //if(secondclick != true){
      else if (board[r][c] == selected) {
        stroke(#FA6060);
        strokeWeight(10);
        fill(255, 255, 255, 0);
        rect(c*100, r*100, 100, 100);
      }
      //}
      c++;
      if (c >= 8) {
        r++;
        c = 0;
      }
    }

    if (selecting == true) {
      if ( piecechosen == empty) {
        imagechosen = paw;
      }
      if (piecechosen == pw) {
        imagechosen = pawnwhite;
      }
      if (piecechosen == rw) {
        imagechosen = rookwhite;
      }
      if (piecechosen == nw) {
        imagechosen = knightwhite;
      }
      if (piecechosen == bw) {
        imagechosen = bishopwhite;
      }
      if (piecechosen == qw) {
        imagechosen = queenwhite;
      }
      if (piecechosen == kw) {
        imagechosen = kingwhite;
      }
      if (piecechosen == pb) {
        imagechosen = pawnblack;
      }
      if (piecechosen == rb) {
        imagechosen = rookblack;
      }
      if (piecechosen == nb) {
        imagechosen = knightblack;
      }
      if (piecechosen == bb) {
        imagechosen = bishopblack;
      }
      if (piecechosen == qb) {
        imagechosen = queenblack;
      }
      if (piecechosen == kb) {
        imagechosen = kingblack;
      }

      image(imagechosen, mouseX-50, mouseY-50, 100, 100);
    }
    

    //println("mode:"+mode);
  } else if (mode == pawnpromotion) {
    background(215, 185, 120);
    stroke(165, 140, 95);
    line(400, 30, 400, 770);
    line(30, 400, 770, 400);
    imageMode(CENTER);
    image(knightblack, 200, 200, 200, 200);
    image(rookblack, 600, 200, 200, 200);
    image(bishopblack, 200, 600, 200, 200);
    image(queenblack, 600, 600, 200, 200);
  } else if (mode == gameover) {
    image(gameoverscreen, 0, 0, 800, 800);
    textAlign(CENTER, CENTER);
    textSize(100);
    fill(0, 0, 0);
    text("GOOD GAME!", 400, 350);

    textSize(50);
    text("Click to Play Again", 400, 450);
  }
  if (myclient.available() >0) {
    String coords = myclient.readString();
    //println("coords");
    String[] rc = coords.split(",");
    int piecemoved;

    pr = int( rc[0] );
    pc = int( rc[1] );
    er = int( rc[2] );
    ec = int( rc[3] );
    piecemoved = int(rc[4]);
    //if (pr == 99) {
    //  reset = true;
    //}else 
    //println(pr);
    if (pr == 199||pc== 199||er == 199||ec == 199) {
      //println("yessir");
      mode = playing;
    } else if (pr == 299) {
      mode = gameover;
    } else if (pr == 399) {
      mode = start;
    } else {
      board[er][ec] = piecemoved;
      board[pr][pc] = empty;
    }
  }
}


void mouseReleased() {
  if (mode == start) {
    myclient.write("199"+","+"199"+ "," +"199"+ "," +"199"+ "," +"199");
    reset = true;
    mode = playing;
  } else if ( mode == playing) {
    imageMode(CORNER);

    if (secondclick == false) {
      pr = mouseY/100;
      pc = mouseX/100;

      piecechosen = board[pr][pc];
      if (pc == 7) {
        rightedge = true;
      } else if (pc == 0) {
        leftedge = true;
      } 
      if (pr == 7) {
        downedge = true;
      }
      //println(piecechosen);
      if (piecechosen == pw || piecechosen == rw || piecechosen == kw || piecechosen == bw || piecechosen == nw || piecechosen == qw) {
        canmove = true;
      }
      if (piecechosen == rw) {
        for (int i = pr+1; i<=7; i++) {
          possiblemoves.add(i+","+pc+"!");
          if (board[i][pc] != 0) {
            //println("***"+downstepsallowed);
            break;
          }
        }
        for (int i = pr-1; i>=0; i--) {
          possiblemoves.add(i+","+pc+"!");
          if (board[i][pc] != 0) {
            //println("***"+upstepsallowed);
            break;
          }
        }
        for (int i = pc+1; i<=7; i++) {
          possiblemoves.add(pr+","+i+"!");
          if (board[pr][i] != 0) {
            //println("***"+downstepsallowed);
            break;
          }
        }
        for (int i = pc-1; i>=0; i--) {
          possiblemoves.add(pr+","+i+"!");
          if (board[pr][i] != 0) {
            //println("***"+downstepsallowed);
            break;
          }
        }
      }
      if (piecechosen == bw) {
        int a = pr+1;
        int b = pc+1;
        while (a<=7&&b<=7) {
          possiblemoves.add(a+","+b+"!");
          if (board[a][b] !=0) {
            break;
          }
          a++;
          b++;
        }
        int c = pr+1;
        int d = pc-1;
        while (c<=7&&d>=0) {
          possiblemoves.add(c+","+d+"!");
          if (board[c][d] !=0) {
            break;
          }
          c++;
          d--;
        }
        int e = pr-1;
        int f = pc-1;
        while (e>=0&&f>=0) {
          possiblemoves.add(e+","+f+"!");
          if (board[e][f] !=0) {
            break;
          }
          e--;
          f--;
        }
        int g = pr-1;
        int h = pc+1;
        while (g>=0&&h<=7) {
          possiblemoves.add(g+","+h+"!");
          if (board[g][h] !=0) {
            break;
          }
          g--;
          h++;
        }
      }
      if (piecechosen == nw) {
        possiblemoves.add((pr-2)+","+(pc-1)+"!");
        possiblemoves.add((pr-2)+","+(pc+1)+"!");
        possiblemoves.add((pr+2)+","+(pc-1)+"!");
        possiblemoves.add((pr+2)+","+(pc+1)+"!");
        possiblemoves.add((pr-1)+","+(pc+2)+"!");
        possiblemoves.add((pr-1)+","+(pc-2)+"!");
        possiblemoves.add((pr+1)+","+(pc+2)+"!");
        possiblemoves.add((pr+1)+","+(pc-2)+"!");
      }
      if (piecechosen == pw) {
        if (pr==1) {
          possiblemoves.add((pr+2)+","+pc+"!");
        }
        if (leftedge == true) {
          if (board[pr+1][pc+1] != 0) {
            possiblemoves.add((pr+1)+","+(pc+1)+"!");
          }
        } else if (rightedge == true) {
          if (board[pr+1][pc-1] != 0) {
            possiblemoves.add((pr+1)+","+(pc+1)+"!");
          }
        } else if (leftedge == false&&rightedge ==false) {
          if (board[pr+1][pc+1] != 0) {
            possiblemoves.add((pr+1)+","+(pc+1)+"!");
          }
          if (board[pr+1][pc-1] != 0) {
            possiblemoves.add((pr+1)+","+(pc-1)+"!");
          }
        }
        if (downedge == false) {
          if (board[pr+1][pc] == 0) {
            possiblemoves.add((pr+1)+","+pc+"!");
          }
        }
        //println("down"+downedge+pr);
      }
      if (piecechosen == qw) {
        for (int i = pr+1; i<=7; i++) {
          possiblemoves.add(i+","+pc+"!");
          if (board[i][pc] != 0) {
            //println("***"+downstepsallowed);
            break;
          }
        }
        for (int i = pr-1; i>=0; i--) {
          possiblemoves.add(i+","+pc+"!");
          if (board[i][pc] != 0) {
            //println("***"+upstepsallowed);
            break;
          }
        }
        for (int i = pc+1; i<=7; i++) {
          possiblemoves.add(pr+","+i+"!");
          if (board[pr][i] != 0) {
            //println("***"+downstepsallowed);
            break;
          }
        }
        for (int i = pc-1; i>=0; i--) {
          possiblemoves.add(pr+","+i+"!");
          if (board[pr][i] != 0) {
            //println("***"+downstepsallowed);
            break;
          }
        }
        int a = pr+1;
        int b = pc+1;
        while (a<=7&&b<=7) {
          possiblemoves.add(a+","+b+"!");
          if (board[a][b] !=0) {
            break;
          }
          a++;
          b++;
        }
        int c = pr+1;
        int d = pc-1;
        while (c<=7&&d>=0) {
          possiblemoves.add(c+","+d+"!");
          if (board[c][d] !=0) {
            break;
          }
          c++;
          d--;
        }
        int e = pr-1;
        int f = pc-1;
        while (e>=0&&f>=0) {
          possiblemoves.add(e+","+f+"!");
          if (board[e][f] !=0) {
            break;
          }
          e--;
          f--;
        }
        int g = pr-1;
        int h = pc+1;
        while (g>=0&&h<=7) {
          possiblemoves.add(g+","+h+"!");
          if (board[g][h] !=0) {
            break;
          }
          g--;
          h++;
        }
      }
      if (piecechosen == kw) {
        for (int i = pc-1; i<=pc+1; i++) {
          possiblemoves.add((pr-1)+","+i+"!");
        }
        for (int i = pc-1; i<=pc+1; i++) {
          possiblemoves.add(pr+","+i+"!");
        }
        for (int i = pc-1; i<=pc+1; i++) {
          possiblemoves.add((pr+1)+","+i+"!");
        }
      }

      //selected = board[pr][pc];// = selected;
      if (canmove == true) {
        selecting = true;
        secondclick = true;
        board[pr][pc] = selected;
        //println(board[pr][pc]);
        //board[pr][pc] = empty;
      }
    } else {
      er = mouseY/100;
      ec = mouseX/100;
      if (possiblemoves.contains(er+","+ec+"!") ) {
        validmove = true;
        
        if (piecechosen == pw && er == 7) {
          mode = pawnpromotion;
        }
      }
      println(kingcount);

      if (board[er][ec]*piecechosen <= 0 && validmove == true) {
        myclient.write(pr+","+pc+ "," +er+ "," +ec+ "," +piecechosen);
        board[pr][pc] = empty;
        board[er][ec] = piecechosen;
      } else {
        board[pr][pc] = piecechosen;
      }

      piecechosen = empty;
      selecting = false;

      //println(board[er][ec]);

      secondclick = false;
      canmove = false;
      validmove = false;

      possiblemoves.clear();
    }
  } else if (mode == pawnpromotion) {
    if (mouseX<400 && mouseY<400) {
      promotedpawn = nw;
    } else if (mouseX>400 &&mouseY<400) {
      promotedpawn = rw;
    } else if (mouseX<400 &&mouseY>400) {
      promotedpawn = bw;
    } else if (mouseX>400 &&mouseY>400) {
      promotedpawn = qw;
    }
    board[er][ec] = promotedpawn;
    myclient.write(pr+","+pc+ "," +er+ "," +ec+ "," +promotedpawn);
    //println("peekaboo"+promotedpawn);
    mode = playing;
  } else if (mode == gameover) {
    myclient.write("399"+","+"399"+","+"399"+","+"399"+","+"399");
    mode = start;
  }
}

void keyReleased() {
  if (mode == playing) {
    if (key == ENTER) {
      reset = true;
      //myclient.write("99"+","+"99"+","+"99"+","+"99"+","+"99");
    }
  }
}