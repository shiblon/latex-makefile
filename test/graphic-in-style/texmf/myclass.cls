\NeedsTeXFormat{LaTeX2e}%
\ProvidesClass{myclass}[Test class]%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
%% ------------------- option parsing ----------------------------
\ProcessOptions\relax
%% ----------------- package loading -----------------------------
\LoadClass{article}%
\RequirePackage{graphicx}

\renewcommand{\maketitle}{%
  Title page
}%
