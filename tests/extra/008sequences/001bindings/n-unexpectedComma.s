main {
    a : seq<int> := [];
    a : seq<int> := [0];
    a : seq<int> := [0,1,2];
    a : seq<top> := [0, 0.1, (3+4)];
    a : seq<top> := [0, 0.1, (3+4), [0, 0.1, (3+4)]];
    a : seq<char> := "hello";
    a : seq<char> := "";
    
    ## fail
    a : seq<int> := [,];
    
};