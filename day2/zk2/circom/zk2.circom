pragma circom 2.1.0;

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}

template GreaterThan(n) {
    signal input in[2];
    signal output out;

    component lt = LessThan(n);

    lt.in[0] <== in[1];
    lt.in[1] <== in[0];
    lt.out ==> out;
}

template ZK2() {
    signal input x;
    signal input delta;    
    signal output y;    
    signal x_square;
    signal delta_square;

    component gt = GreaterThan(252);
    gt.in[0] <== 1;
    gt.in[1] <== x;
    gt.out === 0;

    x_square <== x * x;
    delta_square <== delta * delta;

    168700*x_square + delta_square === 1 + 168696 * x_square * delta_square;
    y <== delta;
}


component main = ZK2();