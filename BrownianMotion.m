function BrownianMotion
n = 1000;
s = .02;
nframes = 3000;

x = rand(n,1)-0.5;
y = rand(n,1)-0.5;

h = plot(x, y, '.');
set(h,'MarkerSize',10);
%set(h,'EraseMode','xor');
set(h,'Color','red');
axis([-1 1 -1 1]);
axis square;
grid off;
M = moviein(nframes);

for k = 1:nframes
    x = x + s*(rand(n,1)-0.5);
    y = y + s*(rand(n,1)-0.5);
    set(h , 'XData' , x , 'YData' , y);
    M(: , k) = getframe;
end;

pause;
movie(M,0);