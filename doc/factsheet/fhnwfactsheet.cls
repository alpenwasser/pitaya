%%
%% This is file `fhnwfactsheet.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% fhnwfactsheet.dtx  (with options: `class')
%%     Author: Raphael Frey <webmaster@alpenwasser.net>
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fhnwfactsheet}%
    [2017/07/12 v1.0.0 PDF-LaTeX class for FHNW fact sheets]





\newif\if@english
\newif\if@german
\DeclareOption{english}{\@englishtrue\@germanfalse}
\DeclareOption{german}{\@germantrue\@englishfalse}
\DeclareOption{deutsch}{\@germantrue\@englishfalse}
\ExecuteOptions{english,german,deutsch}
\ProcessOptions

\LoadClass{report}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{rviewport}
\RequirePackage{multicol}
\RequirePackage[inline]{enumitem}
\RequirePackage{geometry}
\RequirePackage[scaled=0.95]{helvet}
\renewcommand\familydefault{\sfdefault}
\RequirePackage{xcolor}
\RequirePackage{rotating}
\definecolor{parties}{HTML}{666666}
\definecolor{title}{HTML}{000066}
\definecolor{summary}{HTML}{666666}
\colorlet{boxbg}{cyan!50!blue!20!white}
\RequirePackage{tcolorbox}
\RequirePackage{booktabs}
\RequirePackage[binary-units=true]{siunitx}
\sisetup{range-phrase=--}
\RequirePackage[%
    hidelinks=true,
    bookmarksnumbered=true]{hyperref}
\if@english
    \RequirePackage[english]{babel}
\fi
\if@german
    \RequirePackage[ngerman]{babel}
\fi

\geometry{a4paper,twoside=false}
\newlength{\factpageouter}
\newlength{\factpageinner}
\newlength{\factpagetop}
\newlength{\factpagebottom}
\newlength{\factpagewidth}
\newlength{\factgraphicswidth}
\newlength{\testl}
\setlength{\factpageouter}{25mm}
\setlength{\factpageinner}{25mm}
\setlength{\factpagetop}{8mm}
\setlength{\factpagebottom}{30mm}
\setlength{\factpagewidth}{\paperwidth}
\addtolength{\factpagewidth}{-\factpageinner}
\addtolength{\factpagewidth}{-\factpageouter}
\setlength{\factgraphicswidth}{50mm}
\geometry{outer=\factpageouter,inner=\factpageinner,%
          top=\factpagetop,    bottom=\factpagebottom}

\let\newcol\newpage
\newenvironment{factpage}
    {\noindent\begin{minipage}[t][0pt]{\factpagewidth}}
    {\end{minipage}}
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                     {-2.5ex \@plus -1ex \@minus -.2ex}%
                                     {1ex}%
                                     %{1ex \@plus.2ex}% default
                                     {\large\bfseries\color{title}}*}
\let\subsection\@undefined
\let\subsubsection\@undefined
\let\paragraph\@undefined
\let\subparagraph\@undefined
\iflanguage{english}{%
    \newcommand*{\lang@team}    {\textbf{Project Team: }}
    \newcommand*{\lang@client}  {\textbf{Client: }}
    \newcommand*{\lang@coach}   {\textbf{Coach: }}
    \newcommand*{\lang@coaches} {\textbf{Coaches: }}
    \newcommand*{\lang@expert}  {\textbf{Expert: }}
    \newcommand*{\lang@experts} {\textbf{Experts: }}
    \newcommand*{\lang@partner} {\textbf{Industry Partner: }}
    \newcommand*{\lang@partners}{\textbf{Industry Partners: }}
    \newcommand*{\lang@source}  {\textit{Source: }}
}{}
\iflanguage{ngerman}{%
    \newcommand*{\lang@team}    {\textbf{Arbeitsgruppe: }}
    \newcommand*{\lang@client}  {\textbf{Auftraggeber: }}
    \newcommand*{\lang@coach}   {\textbf{Betreuer: }}
    \newcommand*{\lang@coaches} {\textbf{Betreuer: }}
    \newcommand*{\lang@expert}  {\textbf{Experte: }}
    \newcommand*{\lang@experts} {\textbf{Experten: }}
    \newcommand*{\lang@partner} {\textbf{Industriepartner: }}
    \newcommand*{\lang@partners}{\textbf{Industriepartner: }}
    \newcommand*{\lang@source}  {\textit{Quelle: }}
}{}
\newcommand*{\team}[1]
    {\gdef\@team    {{\footnotesize\color{parties}\lang@team#1}}}
\newcommand*{\client}[1]
    {\gdef\@client  {{\footnotesize\color{parties}\lang@client#1}}}
\newcommand*{\coach}[1]
    {\gdef\@coach   {{\footnotesize\color{parties}\lang@coach#1}}}
\newcommand*{\coaches}[1]
    {\gdef\@coaches {{\footnotesize\color{parties}\lang@coaches#1}}}
\newcommand*{\expert}[1]
    {\gdef\@expert  {{\footnotesize\color{parties}\lang@expert#1}}}
\newcommand*{\experts}[1]
    {\gdef\@experts {{\footnotesize\color{parties}\lang@experts#1}}}
\newcommand*{\partner}[1]
    {\gdef\@partner {{\footnotesize\color{parties}\lang@partner#1}}}
\newcommand*{\partners}[1]
    {\gdef\@partners{{\footnotesize\color{parties}\lang@partners#1}}}
\renewcommand\maketitle{\par
    \begingroup
        {\Huge\color{title}\@title}\par
        \vspace{2em}
        \global\let\maketitle\relax
        \global\let\@maketitle\relax
        \global\let\title\relax
        \global\let\date\relax
        \global\let\@title\@empty
        \global\let\@date\@empty
    \endgroup
}
\newlength{\placeholderbase}
\newcommand\placeholderpics{%
    \setlength{\placeholderbase}{48mm}
    \begin{tikzpicture}[x=\placeholderbase,y=\placeholderbase,draw=black!50!white,very thick]
        \draw (0,0) -- (1.618,1);
        \draw (0,1) -- (1.618,0);
        \draw (0,0) -- (1.618,0) -- (1.618,1) -- (0,1) -- cycle;
        \node[draw,fill=white] at (0.809,0.5) {\large Beautiful Picture!};
    \end{tikzpicture}
    \begin{tikzpicture}[x=\placeholderbase,y=\placeholderbase,draw=black!50!white,very thick]
        \draw (0,0) -- (1.618,1);
        \draw (0,1) -- (1.618,0);
        \draw (0,0) -- (1.618,0) -- (1.618,1) -- (0,1) -- cycle;
        \node[draw,fill=white] at (0.809,0.5) {\large Amazing Graphics!};
    \end{tikzpicture}\par
    {\footnotesize Beautiful Picture and Amazing Graphics}
}
\newcommand\fscontent[1]{\gdef\fs@content{#1}}
\newcommand\fs@makecontent{\par
    \vspace{1em}\begin{multicols}{3}
        \ifdef{\fs@content}{\fs@content}\par
    \end{multicols}
}
\newcommand\fssummary[1]{\gdef\fs@summary{#1}}
\newcommand\fs@makesummary{\par
    \vspace{0.25em}\noindent\begin{minipage}{\textwidth}\large
        \ifdef{\fs@summary}{\color{summary}\fs@summary}\par
    \end{minipage}%
}
\newcommand\fsgraphics[1]{\gdef\fs@graphics{#1}}
\newcommand\graphicssource[1]{\gdef\fs@graphicssource{#1}}
\newcommand\graphicscaption[1]{\mbox{#1}}
\newcommand\fs@makegraphics{\par
    \vspace{1em}\noindent\begin{minipage}[b]{\textwidth}%
        \footnotesize\raggedright
        \ifdef{\fs@graphics}{\fs@graphics}\par\par
        \ifdef{\fs@graphicscaption}{\fs@graphicscaption}\par
    \end{minipage}%
    \begin{minipage}[t]{2ex}\footnotesize\color{parties}
        \ifdef{\fs@graphicssource}{%
            \hspace*{2ex}%
            \turnbox{90}{%
                \hspace*{2ex} \lang@source \fs@graphicssource}}\par
    \end{minipage}%
}
\newcommand\infobox[2]{%
    \gdef\fs@infoboxtitle{#1}%
    \gdef\fs@infoboxcontent{\footnotesize #2}%
}
\newcommand\fs@makeinfobox{
    \begin{tcolorbox}[
            title=\fs@infoboxtitle,
            width=0.66\textwidth,
            arc=0mm,
            before=,
            after=\hfill]
        \fs@infoboxcontent
    \end{tcolorbox}
}
\newcommand\tightlist{%
    \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}%
}
\newcommand\fs@checkinput{%
    \ifdef{\@coach}{%
        \ifdef{\@coaches}{%
            \ClassError{fhnwfactsheet}{Both 'coach' and 'coaches' field defined. Undefine one.}
                {Both the 'coach' and the 'coaches' field are defined. Only one of them should be.}
        }{}%
    }{}%
    \ifdef{\@expert}{%
        \ifdef{\@experts}{%
            \ClassError{fhnwfactsheet}{Both 'expert' and 'experts' field defined. Undefine one.}
                {Both the 'expert' and the 'experts' field are defined. Only one of them should be.}
        }{}%
    }{}%
    \ifdef{\@partner}{%
        \ifdef{\@partners}{%
            \ClassError{fhnwfactsheet}{Both 'partner' and 'partners' field defined. Undefine one.}
                {Both the 'partner' and the 'partners' field are defined. Only one of them should be.}
        }{}%
    }{}%
    \ifdef{\fs@infoboxcontent}{}
        {%
            \ClassError{fhnwfactsheet}{Did you forget to specify your infobox?}
            {The infobox contents are not defined. Make sure your infobox command is properly called.}
        }%
    \ifdef{\fs@infoboxtitle}{}
        {%
            \ClassError{fhnwfactsheet}{Did you forget to specify your infobox?}
            {The infobox title is not defined. Make sure your infobox command is properly called.}
        }%
}
\renewcommand\chapter{%\if@openright\cleardoublepage\else\clearpage\fi
                    \thispagestyle{plain}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \secdef\@chapter\@schapter}
\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                         \refstepcounter{chapter}%
                         \typeout{\@chapapp\space\thechapter.}%
                         \addcontentsline{toc}{chapter}{#1}%
                                   %{\protect\numberline{\thechapter}#1}%
                    \else
                      \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \chaptermark{#1}%
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \if@twocolumn
                      \@topnewpage[\@makechapterhead{#2}]%
                    \else
                      \@makechapterhead{#2}%
                      \@afterheading
                    \fi}
\def\@makechapterhead#1{%
    \begingroup
        \mbox{\Huge\color{title}#1}\par
        \vspace{2em}
    \endgroup
}
\def\@makeschapterhead#1{%
  \vspace*{50\p@}%
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \Huge\color{title} #1\par\nobreak
    \vskip 40\p@
  }}
\renewcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      %\@dottedtocline{0}{0em}{0em}{#1}{#2}\par
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}
\newcommand*\includefactsheet[1]{\input{#1}\makefactsheet\newpage}
\newcommand\makefactsheet{
    \begin{factpage}
        \fs@checkinput
        \chapter{\@title}
        % Must be after \chapter
        % Note: We do not want to overwrite the \chapter pagestyle{plain} everywhere.
        \thispagestyle{empty}
        \fs@makesummary
        \vspace{1ex}
        \fs@makegraphics
        \vspace{1ex}
        \fs@makecontent
        \vspace{1ex}
        \tcbset{
            colback=boxbg,
            colframe=title,
            boxrule=0.5pt,
            toptitle=2pt,
            bottomtitle=1pt,
            titlerule=0.5pt,
        }
        \fs@makeinfobox
        \begin{minipage}[b]{0.30\textwidth}
            \ifdef{\@team}{\@team}{}\par
            \ifdef{\@client}{\@client}{}\par
            \ifdef{\@coach}{\@coach}{}\par
            \ifdef{\@coaches}{\@coaches}{}\par
            \ifdef{\@expert}{\@expert}{}\par
            \ifdef{\@experts}{\@experts}{}\par
            \ifdef{\@partner}{\@partner}{}\par
            \ifdef{\@partners}{\@partners}{}\par
        \end{minipage}
    \end{factpage}\raisebox{6ex}{\hspace{3em}\thepage}
    % Undefine for next fact sheet
    \let\fs@graphics\@undefined
    \let\fs@graphicssource\@undefined
    \let\fs@graphicscaption\@undefined
    \let\@team\@undefined
    \let\@client\@undefined
    \let\@coach\@undefined
    \let\@coaches\@undefined
    \let\@expert\@undefined
    \let\@experts\@undefined
    \let\@partner\@undefined
    \let\@partners\@undefined
    \let\fs@infoboxtitle\@undefined
    \let\fs@infoboxcontent\@undefined
}
\endinput
%%
%% End of file `fhnwfactsheet.cls'.
