function flyingMolecules
R = 8.31434;      % ������������� ������� ����������
mju = 28*10^(-3); % �������� ����� �������� (� ������ ������ �����), ��/����
T = 300;          % ���������� ����������� ��������, �

Vsr = (3*R*T/mju)^0.5; % ������� ������������ �������� ������

n=11; m=11; % n - ���������� ������ �� ��������� y  (���������� �����)
            % m - ���������� ������ �� ����������� x (���������� ��������), ��������������
           
deltaX=1; deltaY=1; % ���������� ����� ���������� ���������
a=deltaX; % ����������� ���������� ����� ��������� ���� �������� a=deltaX
D=1000; % ������� ����� �������� ���������
massa=0.0001; % ����� ������� ������
dt=0.0001; % ��� ��������������
nframes=3000; % ���������� ������
A = zeros(n,m,7); % �������� ������� ������:

%                   A(n,m,1) - ���������� ������� �� x
%                   A(n,m,2) - ���������� ������� �� y
%                   A(n,m,3) - �������� ������� �� x
%                   A(n,m,4) - �������� ������� �� y
%                   A(n,m,5) - ��������� ������� �� x
%                   A(n,m,6) - ��������� ������� �� y
%                   A(n,m,7) - �������� 0 - ������� ����� ���������,
%                              �������� 1 - ������� ����������

% I - ����� ������� �� y (����� ������)
% J - ����� ������� �� x (����� �������)
%------------------------------------------------------------
for I=1:n,
    for J=1:m,         
    A(I,J,1)=(J-1)*deltaX;       % ���������� ��������� ���������
    A(I,J,2)=(I-1)*deltaY;       % �������� (���������� ��������)
    end
end
%------------------------------------------------------------
I=1:n;
J=1:m;
A(1,:,7)=1;
A(n,:,7)=1;                  % ���������� ������������ ������
A(:,1,7)=1;
A(:,m,7)=1;
%------------------------------------------------------------
M = moviein(nframes); % ��������� ������� ��� ������ ������
%------------------------------------------------------------
for I=1:n,
    for J=1:m,
        if A(I,J,7)==0
        znak = (rand-0.5);
            if znak > 0
            znak=1;
            elseif znak < 0
            znak=-1;
            elseif znak==0
            znak=0;
            end
        A(I,J,3)=znak*rand*2*Vsr;       % ���������� ��������� ���������
        znak = (rand-0.5);              % �������� �� ���� x � y
            if znak > 0                 % �������� �������� ���������� �����
            znak=1;                     % ������� ������������ � ����� ����
            elseif znak < 0             % ������������� ��� �������������
            znak=-1;
            elseif znak==0
            znak=0;
            end
        A(I,J,4)=znak*rand*2*Vsr;
        end
    end
end
%------------------------------------------------------------
for k=1:nframes,
for I=1:n,
    for J=1:m,
        if A(I,J,7)==0
            Fx=0;Fy=0;
            for II=1:n,
                for JJ=1:m,
                    if (II~=I && JJ~=J)
                        r = ((A(I,J,1)-A(II,JJ,1))^2+(A(I,J,2)-A(II,JJ,2))^2)^0.5;
                        F = (-D/r)*((a/r)^12-2*(a/r)^6);
                        cosAlpha = (A(I,J,1)-A(II,JJ,1))/r;
                        sinAlpha = (A(I,J,2)-A(II,JJ,2))/r;     % ������ ��������� ��
                        edFx = F*cosAlpha;                      % ���� x � y ��� ������
                        edFy = F*sinAlpha;                      % �������
                        Fx = Fx + edFx;
                        Fy = Fy + edFy;
                    end
                end
            end
            A(I,J,5)=Fx/massa;
            A(I,J,6)=Fy/massa;
        end
    end
end

for I=1:n,
    for J=1:m,
        if A(I,J,7)==0
            A(I,J,3)=A(I,J,3)+A(I,J,5)*dt;          % ������� ������� ������
            A(I,J,4)=A(I,J,4)+A(I,J,6)*dt;          % �� �������� ����� � ���������
                                                    % �� ��� ���������
            A(I,J,1)=A(I,J,1)+A(I,J,3)*dt;
            A(I,J,2)=A(I,J,2)+A(I,J,4)*dt;
        end
    end
end
h=plot(A(:,:,1),A(:,:,2),'.');
set(h,'MarkerSize',1);
axis square;
axis equal;
axis([-1 m -1 n]);
set(h,'Color','blue');
M(: , k) = getframe;
end;
pause;
movie(M,0);