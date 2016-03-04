n=30;   % n - размерность матрицы по вертикали y  (количество строк)
m=30;   % m - размерность матрицы по горизонтали x (количество столбцов)
deltaX=1; deltaY=1; % расстояния между отдельными элементами матрицы, м
load map.m % Загрузка карты частиц
data % Загрузка данных о частицах
dt=0.0001; % шаг интегрирования
nframes=300; % количество кадров
%------------------------------------------------------------
% I - номер частицы по y (номер строки)
% J - номер частицы по x (номер столбца)
kol=0;
for I=1:n,
    for J=1:m,         
        switch map(I,J)
            case 1
                kol=kol+1;      % Подсчет количества частиц на карте
            case 2
                kol=kol+1;
        end
    end
end

A = zeros(kol,7);             % Создание массива частиц

kol=0;
for I=1:n,
    for J=1:m,         
        switch map(I,J)
            case 1
                kol=kol+1;
                A(kol,7)=1;
                A(kol,1)=(J-1)*deltaX;
                A(kol,2)=(I-1)*deltaY;
            case 2                      % Назначение начальных координат частицам
                kol=kol+1;
                A(kol,7)=2;
                A(kol,1)=(J-1)*deltaX;
                A(kol,2)=(I-1)*deltaY;
        end
    end
end

%-------------------------------------------------------------
M = moviein(nframes); % Выделение массива под запись кадров
%------------------------------------------------------------
for I=1:kol,
        if A(I,7)==2
            znak = (rand-0.5);
            if znak > 0
                znak=1;
            elseif znak < 0
                znak=-1;
            elseif znak==0
                znak=0;
            end
            A(I,3)=znak*rand*2*Vsr;       % Назначение начальных скоростей
            znak = (rand-0.5);              % частицам по осям x и y
            if znak > 0                 % Значение скорости колеблется около
                znak=1;                     % средней квадратичной и может быть
            elseif znak < 0             % положительным или отрицательным
                znak=-1;
            elseif znak==0
                znak=0;
            end
            A(I,4)=znak*rand*2*Vsr;
        end
end
%------------------------------------------------------------
for k=1:nframes,
for I=1:kol,
        if A(I,7)==2
            Fx=0;Fy=0;
            for II=1:kol,
                    if (II~=I)
                        r = ((A(I,1)-A(II,1))^2+(A(I,2)-A(II,2))^2)^0.5;
                        F = (-D/r)*((a/r)^12-2*(a/r)^6);
                        cosAlpha = (A(I,1)-A(II,1))/r;
                        sinAlpha = (A(I,2)-A(II,2))/r;     % Расчет ускорений по
                        edFx = F*cosAlpha;                 % осям x и y для каждой
                        edFy = F*sinAlpha;                 % частицы
                        Fx = Fx + edFx;
                        Fy = Fy + edFy;
                    end
            end
            A(I,5)=Fx/massa;
            A(I,6)=Fy/massa;
        end
end

for I=1:kol,
        if A(I,7)==2
            A(I,3)=A(I,3)+A(I,5)*dt;          % Решение методом Эйлера
            A(I,4)=A(I,4)+A(I,6)*dt;          % ДУ движения точки в проекциях
                                                    % на оси координат
            A(I,1)=A(I,1)+A(I,3)*dt;
            A(I,2)=A(I,2)+A(I,4)*dt;
        end
end
h=plot(A(:,1),A(:,2),'.');
set(h,'MarkerSize',1);
axis square;
axis equal;
axis([-deltaY n*deltaY -deltaX m*deltaX]);
set(h,'Color','blue');
M(: , k) = getframe;
end;
pause;
movie(M,0);