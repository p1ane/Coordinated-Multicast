function [ rate,Gamma,Gamma_tilide,Phi_tilide ] = cal_rate_de_par( i,u,Lambda,K_noise)
%%%%%%%%%%%%%%%%%%%%%%确定性等同部分R_1%%%%%%%%%%%%%%%%%%%%%%%%%
%rate,Gamma,Gamma_tilide,Phi_tilide 都是针对用户(i,u)
% Lambda Nt*1  
% i 小区编号 u 用户编号
global Omega;
[Nr,Nt,~] = size(Omega);

%% matrix iteration

error_matrix_accuracy = 10^(-5);
num_iter = 1;
Phi_tilide = eye(Nr);

while 1
    Phi = eye(Nt) + eta(inv(Phi_tilide)*inv(K_noise),i,u)*diag(Lambda);                           %公式(24)
    Phi_tilide_new = eye(Nr) + eta_tilide(inv(Phi)*diag(Lambda),i,u)/K_noise;                     %公式(23)
    error_diff_matrix = norm(Phi_tilide_new - Phi_tilide,'fro');      % iteration error
    Phi_tilide = Phi_tilide_new;
    if error_diff_matrix < error_matrix_accuracy
        break;
    end
    num_iter = num_iter + 1;
end

%% 辅助矩阵
Gamma = eta(inv(Phi_tilide)*inv(K_noise),i,u);
Gamma_tilide = eta_tilide(inv(Phi)*diag(Lambda),i,u);

rate = log(det(eye(Nt)+Gamma*diag(Lambda))) + log(det(Gamma_tilide+K_noise)) - ...
                    trace(eye(Nr)-inv(Phi_tilide));                                               %公式(20)


