import torch
import numpy as np

def generate_adam_reference():
    # Setup
    steps = 1000
    lr = 0.001
    beta1 = 0.9
    beta2 = 0.999
    eps = 1e-8
    
    # Target parameter to optimize
    # Note: The user asked for x = torch.tensor(1), fc = Linear(1,1), etc.
    # But specifically mentioned 'p' as parameters and 'dp' as gradient.
    # To match Simulink which usually takes 'p' and 'dp' directly in the Adam block:
    p_init = torch.tensor([1.0], requires_grad=True)
    optimizer = torch.optim.Adam([p_init], lr=lr, betas=(beta1, beta2), eps=eps)
    
    # Record history
    p_history = []
    dp_history = []
    
    # Input time series for dp (sine shape as requested)
    # Using np.linspace to get a smooth transition over 1000 steps
    t = np.linspace(0, 10, steps)
    dp_values = np.sin(t)
    
    for i in range(steps):
        optimizer.zero_grad()
        
        # Current gradient
        current_dp = torch.tensor([dp_values[i]], dtype=torch.float32)
        
        # Apply gradient manually to p_init.grad
        p_init.grad = current_dp
        
        # Save state BEFORE step (or AFTER depending on how Simulink block is structured)
        # Usually Simulink Adam block takes p(t) and dp(t) and produces p(t+1)
        p_history.append(p_init.item())
        dp_history.append(current_dp.item())
        
        optimizer.step()
        
    # Return as dict of numpy arrays for MATLAB
    return {
        'p_history': np.array(p_history),
        'dp_history': np.array(dp_history),
        'lr': lr,
        'beta1': beta1,
        'beta2': beta2,
        'eps': eps,
        'p_init': 1.0
    }

if __name__ == "__main__":
    data = generate_adam_reference()
    print("Generated reference for 1000 steps")
