def calc():
    import torch

    X = torch.randn(4,3,requires_grad=True)
    dY = torch.randn(4,2)

    dense = torch.nn.Linear(3,2)
    W = dense.weight
    b = dense.bias

    Y = dense(X)
    Y.backward(dY)

    dW = W.grad
    db = b.grad
    dX = X.grad

    return (
        X.tolist(), 
        dX.tolist(), 
        Y.tolist(), 
        dY.tolist(), 
        W.tolist(), 
        dW.tolist(), 
        b.tolist(), 
        db.tolist()
    )
