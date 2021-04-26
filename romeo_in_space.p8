--romeo in space
--by kendar varnor

function _init()
    gamestate=0
   
    star_init()
    meteor_init()
    ball_init()
    romeo_init()
    score_init()
end

function _update()
    if gamestate==0
    and btnp(❎) then
        gamestate=1
        music(0)
    end
   
    if gamestate==1 then
        foreach(star,star_update)
        foreach(meteor,meteor_update)
        foreach(ball,ball_update)
        romeo_update()
    end
   
    if gamestate==2
    and btnp(❎) then
        gamestate=0
        star_init()
        meteor_init()
        ball_init()
        romeo_init()
        score_init()
    end
end

function _draw()
    cls(1)
   
    if gamestate==0 then
        maintitle_draw()
    end
   
    if gamestate==1 then
        foreach(star,star_draw)
        foreach(meteor,meteor_draw)
        foreach(ball,ball_draw)
        romeo_draw()
        life_draw()
        score_draw()
    end
   
    if gamestate==2 then
        gameover_draw()
    end
end
-->8
--romeo functions

function romeo_init()
    --romeo object
    romeo={}
    romeo.x=10
    romeo.y=60
    romeo.vx=2
    romeo.vy=2
    romeo.w=16
    romeo.h=8
    romeo.life=5
end

function romeo_update()
    --move romeo to left
    if btn(⬅️)
    and romeo.x>0 then
        romeo.x-=romeo.vx
    end
   
    --move romeo to right
    if btn(➡️)
    and romeo.x<128-romeo.w then
        romeo.x+=romeo.vx
    end
   
    --move romeo to up
    if btn(⬆️)
    and romeo.y>12 then
        romeo.y-=romeo.vy
    end
   
    --move romeo to down
    if btn(⬇️)
    and romeo.y<128-romeo.h then
        romeo.y+=romeo.vy
    end
   
    --collision romeo/ball
    for b in all(ball) do
        if collision(
                romeo.x,romeo.y,
                romeo.w,romeo.h,
                b.x,b.y,b.w,b.h) then
               
                --sound for collision
                sfx(0)
               
                --romeo gains point
                score=score+1
               
                --romeo gains life
                if score%25==0 then
                    --sound for gaining life
                    sfx(2)
                   
                    --gain 1 life
                    romeo.life=romeo.life+1
                end
               
                --delete ball
                del(ball,b)
                create_ball(
                    rnd(256)+128,rnd(128))
        end
    end
   
    --collision romeo/meteor
    for m in all(meteor) do
        if collision(
                romeo.x,romeo.y,
                romeo.w,romeo.h,
                m.x,m.y,m.w,m.h)
        and m.destroyed==false then
               
                --sound for collision
                sfx(1)
               
                --romeo lost life
                romeo.life=romeo.life-1
               
                --meteor destroyed
                m.destroyed=true
        end
    end
   
    --game over if romeo life = 0
    if romeo.life<=0 then
        --sound for game over
        sfx(3)
       
        --stop the music
        music(-1)
       
        --change to game over screen
        gamestate=2
    end
end

function romeo_draw()
    --draw romeo
    spr(1,romeo.x,romeo.y,2,1)
end
-->8
--ui functions

--life functions
function life_draw()   
    --ui bacnground
    rectfill(0,0,128,11,5)
   
    --draw the heart sprite
    spr(3,2,2)
   
    --draw the life value
    print(": "..romeo.life,12,3,7)
end

--score functions
function score_init()
    score=0
end

function score_draw()
    --draw the score value
    print("score:",70,3)
    print(score,110,3)
end
-->8
--sprites functions

--star functions

function star_init()
    --star object table
    star={}
   
    --create the star object
    function create_star(x,y)
        s={}
        s.x=x
        s.y=y
        add(star,s)
    end
   
    --create the first stars
    for i=1,60 do
        create_star(
            rnd(256),rnd(128))
    end
end

function star_update(s)
    --the star object
    --goes to left
    s.x=s.x-2
   
    if s.x<-32 then
        --delete a star object
        --if offscreen
        del(star,s)
       
        --and create
        --a new star object
        create_star(
            rnd(256)+128,rnd(128))
    end
end

function star_draw(s)
    --draw the star object
    spr(49,s.x,s.y)
end

--meteor functions

function meteor_init()
    --meteor object table
    meteor={}
   
    --create the meteor object
    function create_meteor(x,y)
        m={}
        m.x=x
        m.y=y
        m.w=16
        m.h=16
        m.destroyed=false
        add(meteor,m)
    end
   
    --create the first meteors
    for i=1,12 do
        create_meteor(
            rnd(256)+64,rnd(128))
    end
end

function meteor_update(m)
    --the meteor object
    --goes to left
    m.x=m.x-2
   
    if m.x<-32 then
        --delete a meteor object
        --if offscreen
        del(meteor,m)
       
        --and create
        --a new meteor object
        create_meteor(
            rnd(256)+128,rnd(128))
    end
end

function meteor_draw(m)
    --draw the meteor object
    if m.destroyed==false then
        --draw the sprite
        --for not destroyed
        spr(16,m.x,m.y,2,2)
    elseif m.destroyed==true then
        --draw the sprite
        --for destroyed
        spr(18,m.x,m.y,2,2)
    end
end

--ball functions

function ball_init()
    --ball object table
    ball={}
   
    --create the ball object
    function create_ball(x,y)
        b={}
        b.x=x
        b.y=y
        b.w=8
        b.h=8
        add(ball,b)
    end
   
    --create the first balls
    for i=1,6 do
        create_ball(
            rnd(256)+64,rnd(128))
    end
end

function ball_update(b)
    --the ball object
    --goes to left
    b.x=b.x-2
   
    if b.x<-32 then
        --delete the ball object
        --if offscreen
        del(ball,b)
       
        --and create
        --a new ball object
        create_ball(
            rnd(256)+128,rnd(128))
    end
end

function ball_draw(b)
    --draw the ball object
    spr(48,b.x,b.y)
end
-->8
--collision function

function collision(
    x1,y1,w1,h1,
    x2,y2,w2,h2)

    return x1<x2+w2
        and x1+w1>x2
        and y1<y2+h2
        and y1+h1>y2
end
-->8
--gamestate functions

--draw the main title screen
function maintitle_draw()
    --press x to play
    print(
        "press ❎ to play",
        32,104,9)
   
    --author credits
    print(
    "a game by kendar varnor",
    17,120,13)
   
    --draw stars
    spr(49,42,52)
    spr(49,30,112)
    spr(49,14,72)
    spr(49,6,100)
    spr(49,52,84)
    spr(49,74,110)
    spr(49,72,90)
    spr(49,88,64)
    spr(49,108,54)
    spr(49,116,84)
   
    --draw meteors
    spr(16,8,48,2,2)
    spr(16,88,78,2,2)
    spr(16,22,82,2,2)
    spr(16,108,98,2,2)
   
    --draw romeo
    spr(4,46,48,4,4)
   
    --draw the title
    spr(64,24,6,12,4)
end

--draw the game over screen
function gameover_draw()
    --game over
    print("game over",46,68,7)
   
    --the score
    print("your score",44,94,12)
    print(score,62,102,7)
   
    --press x to play again
    print(
        "press ❎ to play again",
        20,120,9)
       
    --draw romeo ko
    spr(8,50,16,4,4)
end
