pragma circom 2.1.6;

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

template ZK1 () {
    signal input a;
    signal input b;
    signal output c;
    
    component gt1 = GreaterThan(252);
    component gt2 = GreaterThan(252);

    gt1.in[0] <== 1;
    gt1.in[1] <== a;
    gt1.out === 0;

    gt2.in[0] <== 1;
    gt2.in[1] <== b;
    gt2.out === 0;

    c <== a * b;
    c === 58567186824402957966382507182680956225095467533943200425018625513920465170743;
    log("out", c);
}

component main = ZK1();
