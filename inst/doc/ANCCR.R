## ----echo = FALSE, message=FALSE----------------------------------------------
if (requireNamespace("DiagrammeR", quietly = TRUE)) {
    DiagrammeR::mermaid("graph LR;
    E_i-->M_i;
    E_j-->M_j;
    M_j-->SRC;
    M_i-->SRC;
    E_ij-->M_ij;
    M_ij-->PRC;
    M_i-->PRC;
    PRC-->SRC;
    PRC-->NC;
    SRC-->NC;
    NC-->ANCCR;
    CW-->ANCCR;
    ANCCR-->DA;
    DA-->CW;
    CW-->Q;
    SRC-->Q;
", width = "100%")
}

