\NeedsTeXFormat{LaTeX2e}%
\ProvidesClass{myclass}[2014/08/22 Test Class]%
\LoadClass{article}%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
%% ------------------- option parsing ----------------------------
\ProcessOptions\relax
%% ----------------- package loading -----------------------------
\RequirePackage{graphicx}

\renewcommand{\maketitle}{%
  Title page
  \includegraphics{graphic}
}%
