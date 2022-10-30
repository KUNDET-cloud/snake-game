Program snake;
  Uses Crt;
  
  type
    body=array [1..1000] of integer;
  
  const
    ww=120;
    wh=30;

  var
    snakeLength,stepX,stepY,appleX,appleY,points,speed,hp:integer;
    bodyX,bodyY: body;
  
  ///Рисует границы
  procedure drawBorders();
  begin
    textBackground(Green);
    textColor(Magenta);
    gotoXY(1,1);
    write('▓'*ww);
    for var i:=2 to wh-1 do
    begin
      gotoXY(1,i);
      write('▓');
      gotoXY(ww ,i);
      write('▓');
    end;
    write('▓'*ww);
    textBackground(Black);
    
  end;

  /// Смещает массив
  function moveBody(b:body;h:integer):body;
  var nb:body;
  begin
    nb:=b;
    
    for var i:=snakeLength downto 2 do
      nb[i]:= b[i-1];
    nb[1]:=h;
    
    Result:=nb;
  end;
  
  /// Генерация яблока
  procedure appleGenerate();
  begin
    
    appleX:=random(2,119);
    appleY:=random(2,29);
    
    for var i:=1 to snakeLength do
    begin
      if (appleX = bodyX[i]) and (appleY = bodyY[i]) then
        appleGenerate();
    end;
    
    gotoXY(appleX,appleY);
    textColor(Red);
    write('ó');
  end;
  
  /// Управление
  procedure control();
  var
    key:char;
  begin    
    key:=readkey;
    if (key = '2')and(stepY = 0)then
      begin
        stepX:=0;
        stepY:=1;
      end
    else if (key = '4')and(stepX = 0)then
      begin
        stepX:=-1;
        stepY:=0;
      end
    else if (key = '6')and(stepX = 0)then
      begin
        stepX:=1;
        stepY:=0;
      end
    else if (key = '8')and(stepY = 0)then
      begin
        stepX:=0;
        stepY:=-1;
      end
    else if (key = '+')and(speed > 1)then
      speed-=1
    else if (key = '-')and(speed < 5)then
      speed+=1;
    
  end;

  //Заставка
  procedure preview();
  begin
    clrscr;
//    drawBorders();
    textColor(Green);
    gotoXY(20,5);
    write('░██████╗███╗░░██╗░█████╗░██╗░░██╗███████╗░░░░░░░██████╗░░█████╗░███╗░░░███╗███████╗');
    delay(300);
    gotoXY(20,6);
    write('██╔════╝████╗░██║██╔══██╗██║░██╔╝██╔════╝░░░░░░██╔════╝░██╔══██╗████╗░████║██╔════╝');
    delay(300);
    gotoXY(20,7);
    write('╚█████╗░██╔██╗██║███████║█████═╝░█████╗░░█████╗██║░░██╗░███████║██╔████╔██║█████╗░░');
    delay(300);
    gotoXY(20,8);
    write('░╚═══██╗██║╚████║██╔══██║██╔═██╗░██╔══╝░░╚════╝██║░░╚██╗██╔══██║██║╚██╔╝██║██╔══╝░░');
    delay(300);
    gotoXY(20,9);
    write('██████╔╝██║░╚███║██║░░██║██║░╚██╗███████╗░░░░░░╚██████╔╝██║░░██║██║░╚═╝░██║███████╗');
    delay(300);
    gotoXY(20,10);
    write('╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝░░░░░░░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝');

    //Правила
    TextBackground(Red);
    textColor(White);
    gotoXY(33,12);
    write(' Правила:                                                ');
    textBackground(Cyan);
    gotoXY(33,13);
    write('▬ Если ты заденешь хвост или границу, у тебя отнимется ');
    textColor(Red);
    write('♥ ');
    textColor(White);
    gotoXY(33,14);
    write('▬ Каждое съеденное яблоко увеличивает длину на 5 символов');
    gotoXY(33,15);
    write('▬ После каждых 5 яблок скорость увеличивается.           ');

    //Управление
    textBackground(Magenta);
    textColor(White);
    gotoXY(33,16);
    write(' Управление:                                             ');
    TextBackground(Cyan);
    gotoXY(33,17);
    write('▬ Смена направлений: Numpad(2▼,4◄,6►,8▲);                ');
    gotoXY(33,18);
    write('▬ Регулировка скорости: Numpad(+,-)                      ');
    
    while keypressed <> true do
    begin
      
      TextBackground(Black);
      TextColor(White);
      gotoXY(43, 22);
      write('Нажмите любую кнопку, чтобы начать');
      delay(800);
      gotoXY(43, 22);
      write('                                  ');
      delay(200);
      
    end;
    clrScr;
    drawBorders();
  end;
  
  // Вызывается при потере жизни, при условии, что есть хотя бы 1 жизнь
  procedure respawn();
  begin
    // Стереть всю змею
    for var i:=1 to snakeLength do
    begin
      gotoXY(bodyX[i],bodyY[i]);
      write(' ');
      bodyX[i]:=0;
      bodyY[i]:=0;
    end;
    
    bodyX[1]:=2;
    bodyY[1]:=2;
    stepX:=1;
    stepY:=0;
    
    // Минус одно очко жизни
    hp-=1;
    
  end;
  
  /// Игра окончена
  procedure gameOver();
  begin
    clrScr;
    textColor(LightCyan);
    gotoXY(30,10);
    write('░██████╗░░█████╗░███╗░░░███╗███████╗  ░█████╗░██╗░░░██╗███████╗██████╗░');
    delay(200);
    gotoXY(30,11);
    write('██╔════╝░██╔══██╗████╗░████║██╔════╝  ██╔══██╗██║░░░██║██╔════╝██╔══██╗');
    delay(200);
    gotoXY(30,12);
    write('██║░░██╗░███████║██╔████╔██║█████╗░░  ██║░░██║╚██╗░██╔╝█████╗░░██████╔╝');
    delay(200);
    gotoXY(30,13);
    write('██║░░╚██╗██╔══██║██║╚██╔╝██║██╔══╝░░  ██║░░██║░╚████╔╝░██╔══╝░░██╔══██╗');
    delay(200);
    gotoXY(30,14);
    write('╚██████╔╝██║░░██║██║░╚═╝░██║███████╗  ╚█████╔╝░░╚██╔╝░░███████╗██║░░██║');
    delay(200);
    gotoXY(30,15);
    write('░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝  ░╚════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝');
    
    delay(3000);
    
  end;
  
  ///Вывод и обновление информации
  procedure updateInfo();
  begin
    // Вывод кол-ва очков
    textColor(Yellow);
    gotoXY(20,30);
    write(' points: ',points,' ');
    
    // Вывод текущей скорости
    textColor(Crt.LightCyan);
    gotoXY(34,30);
    write(' speed: ',speed,' ');
    
    // Вывод кол-ва очков жизней
    gotoXY(2,wh);
    write('   '*5);
    gotoXY(2,wh);
    textColor(Red);
    write(' ♥ '*hp);
  end;
    
  
  ///Обработка событий игры
  procedure gameHandler();
  begin
    
    // Если змея съела яблоко...
    if (bodyX[1] = appleX)and(bodyY[1] = appleY) then
    begin
      appleGenerate();
      points+=1;      
      // Увеличение скорости после каждых 5 яблок
      if (speed > 1) and (points mod 5 = 0) then
        speed-=1;
      snakeLength+=5;
      
      //Добавление одной жизни после каждых 10 яблок
      if (points mod 10 = 0)and(hp < 5) then
        hp+=1;
    end;
    
    // Если змея столкнулась с хвостом...
    for var i:=2 to snakeLength do
    begin
      if (bodyX[1] = bodyX[i]) and (bodyY[1] = bodyY[i]) then
      begin
        respawn();
      end;
    end;
    
    // Если голова змеи задела границу...
    if ( (bodyX[1]+stepX = 120) or (bodyX[1]+stepX = 1) ) or ( (bodyY[1]+stepY = 30) or (bodyY[1]+stepY = 1) ) then
    begin
      respawn();
    end;
    
  end;

  /// Запуск игры
  procedure gameStart();
  begin
    
    SetWindowSize(ww,wh);
    
    hideCursor();
    
    preview();  
    appleGenerate();
    
    snakeLength:=5;
    bodyX[1]:=2;
    bodyY[1]:=2;
    stepX:=1;
    hp:=5;
    speed:=5;
    points:=0;
    
    gotoXY(2,wh);
    write(' ♥ '*hp);
    
    // Запуск игрового процесса
    while true do
    begin
      //Отрисовка змеи  
      for var i:=1 to snakeLength do
      begin
       if bodyX[i] <> 0 then
        begin
          textColor(LightGreen);
          gotoXY(bodyX[i], bodyY[i]);
          if snakeLength = i then
            write(',')
          else if i = 1 then
            write('@')
          else
            write('o'); 
        end;
      end;
      
      delay(speed*20);        
      
      //Стирание хвоста
      gotoXY(bodyX[snakeLength],bodyY[snakeLength]);
      write(' ');
      
      //Шаг
      bodyX:=moveBody(bodyX,bodyX[1]+stepX);
      bodyY:=moveBody(bodyY,bodyY[1]+stepY);
      
      // Управление
      if keypressed then
        control();
      
      // Если змея потеряла все очки жизни
      if hp=0 then
      begin
        gameOver();
        break;
      end;
      
      gameHandler();
      updateInfo();
      
    end;
    gameStart;
  end;

begin
  
  gameStart;
  
end.