\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{alpenspecs}%
    [2017/07/11 v1.0.0 PDF-LaTeX class for our thesis specifications]
\LoadClassWithOptions{memoir}
\newif\ifhex
\newif\ifpaper
\RequirePackage[rmx,nott,intlimits,sumlimits]{kpfonts}
\renewcommand\familydefault{\sfdefault}
\RequirePackage[scaled=0.8125]{DejaVuSansMono}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{xcolor}
\globalcolorstrue
\newcommand*\testcolor[1]{\tikz \fill[#1] (0em,0ex) rectangle (2em,2ex);}
\newcommand*\rowtestcolor[1]{#1 & \tikz \fill[#1] (0em,0ex) rectangle (2em,2ex);}
\definecolor{da0}{HTML}{002B36}  \definecolor{da1}{HTML}{073642}
\definecolor{da2}{HTML}{008080}  \definecolor{da3}{HTML}{800080}
\definecolor{da4}{HTML}{404040}
\definecolor{br0}{HTML}{BEB9AA}  \definecolor{br1}{HTML}{EEE8D5}
\definecolor{br2}{HTML}{FDF6E3}
\definecolor{ct0}{HTML}{CB4B16}  \definecolor{ct1}{HTML}{DC322F}
\definecolor{ct2}{HTML}{DC3682}  \definecolor{ct3}{HTML}{268BD2}
\definecolor{ct4}{HTML}{2AA198}  \definecolor{ct5}{HTML}{B58900}
\definecolor{ct6}{HTML}{859900}  \definecolor{sq0}{HTML}{F7FBFF}
\definecolor{sq1}{HTML}{EFF3FF}  \definecolor{sq2}{HTML}{DECDF7}
\definecolor{sq3}{HTML}{C6DBEF}  \definecolor{sq4}{HTML}{BDD7E7}
\definecolor{sq5}{HTML}{9ECAE1}  \definecolor{sq6}{HTML}{6BAED6}
\definecolor{sq7}{HTML}{4292C6}  \definecolor{sq8}{HTML}{3182BD}
\definecolor{sq9}{HTML}{2171B5}  \definecolor{sqA}{HTML}{08519C}
\definecolor{sqB}{HTML}{084594}  \definecolor{sqC}{HTML}{08306B}
\definecolor{dv-7}{HTML}{8E0152} \definecolor{dv-6}{HTML}{C51B7D}
\definecolor{dv-5}{HTML}{D01C8B} \definecolor{dv-4}{HTML}{DE77AE}
\definecolor{dv-3}{HTML}{E9A3C9} \definecolor{dv-2}{HTML}{F1B6DA}
\definecolor{dv-1}{HTML}{FDE0EF} \definecolor{dv+0}{HTML}{F7F7F7}
\definecolor{dv+1}{HTML}{D1E5F0} \definecolor{dv+2}{HTML}{92C5DE}
\definecolor{dv+3}{HTML}{67A9CF} \definecolor{dv+4}{HTML}{4393C3}
\definecolor{dv+5}{HTML}{0571B0} \definecolor{dv+6}{HTML}{2166AC}
\definecolor{dv+7}{HTML}{053061}
\definecolor{q0}{named}{ct3}   \definecolor{q1}{named}{sqB}
\definecolor{q2}{named}{ct2}   \definecolor{q3}{named}{da3}
\definecolor{q4}{HTML}{FEC44F} \definecolor{q5}{named}{ct0}
\definecolor{q6}{HTML}{80EA82} \definecolor{q7}{HTML}{2E7D32}
\RequirePackage{tikz}
\usetikzlibrary{calc}
\usetikzlibrary{fadings}
\RequirePackage{pgfplots}
% TODO: uncomment this again after noah fixed his distro ...
% \pgfplotsset{compat=1.14}
\usepgfplotslibrary{external}
%%\tikzexternalize[prefix=tikzCache/]
\tikzexternalize[prefix=tikzCache/,mode=list and make] %% conflicts with tcolorbox
\pgfmathsetmacro\AT@paperwidth{21}
\pgfmathsetmacro\AT@paperheight{29.7}
\pgfmathsetmacro\AT@numberOfSidesHorizontally{22}
\pgfmathsetmacro\AT@side
    {\AT@paperwidth / \AT@numberOfSidesHorizontally}
\pgfmathtruncatemacro\AT@totCols
    {0.666667 * \AT@numberOfSidesHorizontally + 1}
\pgfmathcos{30}
\pgfmathsetmacro\AT@height
    {\pgfmathresult * \AT@side}
\pgfmathtruncatemacro\AT@numberOfHeightsVertically
    {\AT@paperheight / \AT@height}
\pgfmathtruncatemacro\AT@totRows
    {0.5 * \AT@numberOfHeightsVertically + 1}
\pgfmathtruncatemacro\AT@totRowsChap
    {0.1333 * \AT@numberOfHeightsVertically + 1}
\AtBeginDocument{%
    \ifpaper
        \foreach \y in {0,...,\AT@totRowsChap} {%
            \foreach \x in {0,...,\AT@totCols}{%
                \pgfmathsetmacro\mix
                    {100 * \x / \AT@totCols}%
                \pgfmathsetmacro\mixvert
                    {100 * \y / \AT@totRowsChap}%
                \colorlet{hex-\x}{white!\mix!br0}%
                \colorlet{hex-\x-\y}{white!\mixvert!hex-\x}%
                \colorlet{hexframecol-\x}{white!\mix!br2}%
                \colorlet{hexframecol-\x-\y}
                    {white!\mixvert!hexframecol-\x}%
                \colorlet{chapcol-\x}{dv-4!\mix!dv-7}%
                \colorlet{chapcol-\x-\y}
                    {dv-2!\mixvert!chapcol-\x}%
                \colorlet{appcol-\x}{ct4!\mix!da2}%
                \colorlet{appcol-\x-\y}{white!\mixvert!appcol-\x}%
            }%
        }%
    \else
        \foreach \x in {0,...,\AT@totCols}{%
            \pgfmathsetmacro\leftTransp
                {100 *  \x    / \AT@totCols}%
            \pgfmathsetmacro\rightTransp
                {100 * (\x+1) / \AT@totCols}%
            \tikzfading[%
                name=hexfade \x,
                right color=transparent!\rightTransp,
                left color=transparent!\leftTransp]%
        }%
    \fi
}
\newcommand\AT@providehexagonpath[3]{%
    ($(current page.north west) +
        (1.5 * #1 * \AT@side,
            #3 * \AT@height - #2 * 2 * \AT@height)$)
    -- ++(   0:\AT@side)
    -- ++( -60:\AT@side)
    -- ++(-120:\AT@side)
    -- ++(-180:\AT@side)
    -- ++(-240:\AT@side) -- cycle;
}
\newcommand\fullhexpage[2]{%
    \ifhex
        \tikzset{external/export next=false}%
        \begin{tikzpicture}[remember picture,overlay,x=1cm,y=1cm]
            \path[clip]
                (current page.north west)
                rectangle
                (current page.south east);
            \foreach \y in {0,...,\AT@totRows} {%
                \foreach \x in {0,...,\AT@totCols} {%
                    \pgfmathsetmacro\AT@isodd{mod(\x,2)}
                    \fill[fill=br2,draw=br1]
                        \AT@providehexagonpath{\x}{\y}{\AT@isodd}
                }
            }
            % Create vertical contrast bar on left side.
            % Put it inside scope for clipping.
            \begin{scope}
                \path[clip]
                    (current page.north west)
                    rectangle
                    ($(current page.south west) +
                        (3.5 * \AT@side,0)$);
                \foreach \y in {0,...,\AT@totRows} {%
                    \foreach \x in {0,...,2} {%
                        \pgfmathsetmacro\AT@isodd{mod(\x,2)}
                        \fill[fill=#1,draw=#2]
                            \AT@providehexagonpath{\x}{\y}{\AT@isodd}
                    }
                }
            \end{scope}
        \end{tikzpicture}%
    \fi
}
\RequirePackage{tcolorbox}
\tcbuselibrary{listings}
\tcbuselibrary{skins}
\tcbuselibrary{xparse}
\tcbuselibrary{breakable}
\AtBeginDocument{%
    \DeclareTCBListing[blend into=listings]{mybox}{ O{} }{listing only,#1}
}
\lstdefinestyle{tcblatex}{language={[LaTeX]TeX},
    aboveskip={0\p@ \@plus 6\p@}, belowskip={0\p@ \@plus 6\p@},
    columns=fullflexible, keepspaces=true,
    breaklines=true, breakatwhitespace=true,
    basicstyle=\ttfamily\small, extendedchars=true, nolol,
    inputencoding=\kvtcb@listingencoding
 }
\tcbsubskin{octobox}{enhanced}{
    frame code={
        \draw[very thick]
               ([xshift=-3mm,yshift=+1mm]frame.north east)
            -- ([xshift=+0mm,yshift=-2mm]frame.north east)
            -- ([xshift=+0mm,yshift=+2mm]frame.south east)
            -- ([xshift=-3mm,yshift=-1mm]frame.south east)
            -- ([xshift=+3mm,yshift=-1mm]frame.south west)
            -- ([xshift=-0mm,yshift=+2mm]frame.south west)
            -- ([xshift=-0mm,yshift=-2mm]frame.north west)
            -- ([xshift=+3mm,yshift=+1mm]frame.north west)
            -- cycle;
    },
    interior titled code={%
        \path[tcb fill interior]
               ([xshift=-2.7mm,yshift=+1.3mm]interior.north east)
            -- ([xshift=+0.3mm,yshift=-1.7mm]interior.north east)
            -- ([xshift=+0.3mm,yshift=+1.7mm]interior.south east)
            -- ([xshift=-2.7mm,yshift=-1.3mm]interior.south east)
            -- ([xshift=+2.7mm,yshift=-1.3mm]interior.south west)
            -- ([xshift=-0.3mm,yshift=+1.7mm]interior.south west)
            -- ([xshift=-0.3mm,yshift=-1.7mm]interior.north west)
            -- ([xshift=+2.7mm,yshift=+1.3mm]interior.north west)
            -- cycle;
    },
    interior code={%
        \path[tcb fill interior]
               ([xshift=-2.7mm,yshift=+1.3mm]interior.north east)
            -- ([xshift=+0.3mm,yshift=-1.7mm]interior.north east)
            -- ([xshift=+0.3mm,yshift=+1.7mm]interior.south east)
            -- ([xshift=-2.7mm,yshift=-1.3mm]interior.south east)
            -- ([xshift=+2.7mm,yshift=-1.3mm]interior.south west)
            -- ([xshift=-0.3mm,yshift=+1.7mm]interior.south west)
            -- ([xshift=-0.3mm,yshift=-1.7mm]interior.north west)
            -- ([xshift=+2.7mm,yshift=+1.3mm]interior.north west)
            -- cycle;
    },
    title code={%
        \path[tcb fill frame]
               ([xshift=-3mm,yshift=+1mm]frame.north east)
            -- ([xshift=+0mm,yshift=-2mm]frame.north east)
            -- ([xshift=+0.3mm,yshift=-4mm]interior.north east)
            -- ([xshift=-3mm,yshift=-1mm]interior.north east)
            -- ([xshift=+3mm,yshift=-1mm]interior.north west)
            -- ([xshift=-0.3mm,yshift=-4mm]interior.north west)
            -- ([xshift=-0mm,yshift=-2mm]frame.north west)
            -- ([xshift=+3mm,yshift=+1mm]frame.north west)
            -- cycle;
    },
}
\tcbsubskin{octoboxfirst}{octobox}{
    frame code={
        \draw[very thick]
               ([xshift=-3mm,yshift=+1mm]frame.north east)
            -- ([xshift=+0mm,yshift=-2mm]frame.north east)
            -- (frame.south east)
               (frame.south west)
            -- ([xshift=-0mm,yshift=-2mm]frame.north west)
            -- ([xshift=+3mm,yshift=+1mm]frame.north west)
            -- ([xshift=-3mm,yshift=+1mm]frame.north east)
            ;
        \draw[thin,br0]
               (frame.south east)
            -- (frame.south west)
            ;
    },
    interior code={%
        \path[tcb fill interior]
               ([xshift=-2.7mm,yshift=+1.3mm]interior.north east)
            -- ([xshift=+0.3mm,yshift=-1.7mm]interior.north east)
            -- (interior.south east)
            -- (interior.south west)
            -- ([xshift=-0.3mm,yshift=-1.7mm]interior.north west)
            -- ([xshift=+2.7mm,yshift=+1.3mm]interior.north west)
            -- cycle;
    },
    interior titled code={%
        \path[tcb fill interior]
               ([xshift=-2.7mm,yshift=+1.3mm]interior.north east)
            -- ([xshift=+0.3mm,yshift=-1.7mm]interior.north east)
            -- ([xshift=0mm,yshift=-1pt]interior.south east)
            -- ([xshift=0mm,yshift=-1pt]interior.south west)
            -- ([xshift=-0.3mm,yshift=-1.7mm]interior.north west)
            -- ([xshift=+2.7mm,yshift=+1.3mm]interior.north west)
            -- cycle;
    },
    title code={%
        \path[tcb fill frame]
               ([xshift=-3mm,yshift=+1mm]frame.north east)
            -- ([xshift=+0mm,yshift=-2mm]frame.north east)
            -- ([xshift=+0.3mm,yshift=-4mm]interior.north east)
            -- ([xshift=-3mm,yshift=-1mm]interior.north east)
            -- ([xshift=+3mm,yshift=-1mm]interior.north west)
            -- ([xshift=-0.3mm,yshift=-4mm]interior.north west)
            -- ([xshift=-0mm,yshift=-2mm]frame.north west)
            -- ([xshift=+3mm,yshift=+1mm]frame.north west)
            -- cycle;
    }
}
\tcbsubskin{octoboxmiddle}{octobox}{
    frame code={
        \draw[very thick,da1]
               (frame.north east)
            -- (frame.south east)
               (frame.north west)
            -- (frame.south west)
            ;
        \draw[thin,br0]
               (frame.north east)
            -- (frame.north west)
               (frame.south east)
            -- (frame.south west)
            ;
    },
    interior code={%
        \path[tcb fill interior]
               ([xshift=-0.3mm,yshift=-0.5pt]frame.north east)
            -- ([xshift=-0.3mm,yshift=+0.5pt]frame.south east)
            -- ([xshift=+0.3mm,yshift=+0.5pt]frame.south west)
            -- ([xshift=+0.3mm,yshift=-0.5pt]frame.north west)
            -- cycle
            ;
    }
}
\tcbsubskin{octoboxlast}{octobox}{
    frame code={
        \draw[very thick]
               (frame.north east)
            -- ([xshift=+0mm,yshift=+2mm]frame.south east)
            -- ([xshift=-3mm,yshift=-1mm]frame.south east)
            -- ([xshift=+3mm,yshift=-1mm]frame.south west)
            -- ([xshift=-0mm,yshift=+2mm]frame.south west)
            -- (frame.north west)
            ;
        \draw[thin,br0]
               (frame.north east)
            -- (frame.north west)
            ;
    },
    interior code={%
        \path[tcb fill interior]
               ([yshift=+1pt]interior.north east)
            -- ([xshift=+0.3mm,yshift=+1.7mm]interior.south east)
            -- ([xshift=-2.7mm,yshift=-1.3mm]interior.south east)
            -- ([xshift=+2.7mm,yshift=-1.3mm]interior.south west)
            -- ([xshift=-0.3mm,yshift=+1.7mm]interior.south west)
            -- ([yshift=+1pt]interior.north west)
            -- cycle;
            ;
    }
}
\tcbsubskin{octoboxshell}{octobox}{
    colback=da1,
    colframe=br2,
    coltitle=da1,
}
\tcbset{%
    colback=br2,
    coltitle=br2,
    colframe=da1,
    fonttitle=\sffamily,
    skin=octobox,
    shield externalize,
    skin first is subskin of={octoboxfirst}{},
    skin middle is subskin of={octoboxmiddle}{},
    skin last is subskin of={octoboxlast}{},
}
\RequirePackage[%
    pdfauthor=alpenwasser,
    pdfsubject={LaTeX document design},
    pdftitle={alpenwasser's thesis},
    bookmarksnumbered=true,
    pdfkeywords={LaTeX,design,alpenwasser,thesis,class,hexagons},
    colorlinks=true,
    linkcolor=sqB,
    citecolor=ct4,
    urlcolor=dv-6]{hyperref}
\RequirePackage[english]{babel}
\RequirePackage{amsmath}
\RequirePackage[separate-uncertainty=true]{siunitx}
\RequirePackage{counttexruns}
\RequirePackage{morewrites}
%%^^A \href{https://tex.stackexchange.com/questions/5944/minitoc-and-memoir#comment126049_5956}
%%^^A      {\nolinkurl{https://tex.stackexchange.com/questions/5944/minitoc-and-memoir#comment126049_5956}}
%%^^A\RequirePackage{minitoc} % Should probably be loaded after hyperref.
%%^^A\AtBeginDocument{\doparttoc}
\maxsecnumdepth{subsubsection}
\maxtocdepth{subsubsection}
\newcommand\aiiistock{%
    \stockaiii
    \settrimmedsize{297mm}{210mm}{*}
    \setlength{\trimtop}{\stockheight}
    \addtolength{\trimtop}{-\paperheight}
    \setlength{\trimedge}{\stockwidth}
    \addtolength{\trimedge}{-\paperwidth}
    \settrims{0.5\trimtop}{0.5\trimedge}
    \renewcommand*{\trimmarkscolor}{\color{red}}
    \showtrimson
    \checkandfixthelayout
}
\showtrimsoff
\setlrmarginsandblock{0.142857111\paperwidth}{0.190476190\paperwidth}{*}
\setulmarginsandblock{0.111111111\paperheight}{*}{1.5}%
\checkandfixthelayout
\setsecheadstyle{\color{sqB}\Large\bfseries\sffamily}
\setsubsecheadstyle{\color{sqB}\large\bfseries\sffamily}
\setsubsubsecheadstyle{\color{sqB}\bfseries\sffamily}
\addtodef{\printchaptername}{\color{sqB}}{}
\pagestyle{headings}
\captionnamefont{\bfseries\small}
\captiontitlefont{\small}
\captiondelim{: }
\newfixedcaption{\figcaption}{figure}
\newfixedcaption{\tabcaption}{table}
\renewcommand{\part}{%
    \@setuppart
    \fullhexpage{dv-7}{dv-5}
    \secdef\@part\@spart}
\renewcommand*{\partpageend}{%
    \afterpartskip
    \ifm@mnopartnewpage
    \else
        \if@twoside
            \if@openright
                \null
                \thispagestyle{afterpart}%
                \newpage
            \fi
        \fi
    \fi
    \if@tempswa
        \twocolumn
    \fi}
\newcommand\AT@hexagons{%
    \tikzset{external/export next=false}%
    \begin{tikzpicture}[remember picture,overlay,x=1cm,y=1cm]
        \ifpaper
            \path[clip]
                (current page.north west)
                rectangle
                ($(current page.north east) + (-0pt,-11 * \AT@height)$);
        \else
            \path[clip]
                (current page.north west)
                rectangle
                ($(current page.north east) + (-0pt,-11 * \AT@height)$);
        \fi
        \foreach \y in {0,...,\AT@totRowsChap} {%
            \foreach \x in {0,...,\AT@totCols} {%
                \pgfmathsetmacro\AT@isodd{mod(\x,2)}
                \ifpaper
                    \path[fill=hex-\x-\y,draw=hexframecol-\x-\y]
                \else
                    \path[fill=br0,draw=br1,path fading=hexfade \x]
                \fi
                    \AT@providehexagonpath{\x}{\y}{\AT@isodd}
            }%
        }%
    \end{tikzpicture}%
}
\newcommand\AT@numhexagons[4]{%
    \tikzset{external/export next=false}%
    \begin{tikzpicture}[remember picture,overlay,x=1cm,y=1cm]
        \path[clip]
            (current page.north west) rectangle (current page.east);
        \foreach \n in {#1,...,\thechapter} {%
            \pgfkeysgetvalue{/#2 \thechapter/hexagon \n/x}{\x}
            \pgfkeysgetvalue{/#2 \thechapter/hexagon \n/y}{\y}
            \pgfmathsetmacro\AT@isodd{mod(\x,2)}
            \ifpaper
                \path[fill=#3-\x-\y,draw=br1]
            \else
                \path[fill=#4,draw=br1,path fading=hexfade \x]
            \fi
                \AT@providehexagonpath{\x}{\y}{\AT@isodd}
        }%
    \end{tikzpicture}%
}
\newcommand\AT@bottomscreen{%
    \tikzset{external/export next=false}%
    \begin{tikzpicture}[remember picture,overlay,x=1cm,y=1cm]
        \path[clip]
            (current page.north west) rectangle (current page.east);
        \ifpaper\else
            \path[fill=white,path fading=north]%
                ($(current page.north west) - (0pt, 11.1 * \AT@height)$)
                rectangle
                ($(current page.north east) - (0pt,  5.5 * \AT@height)$);
        \fi
    \end{tikzpicture}%
}
\newlength{\edgewidth}
\newcommand\AT@chapstylesetup{%
    \setlength{\afterchapskip}{40pt}%
    \renewcommand*{\chapterheadstart}
        {\ifhex\AT@hexagons\fi\vspace*{40pt}}%
    \renewcommand*{\afterchapternum}{\par\nobreak\vskip 25pt}%
    \setlength{\beforechapskip}{17mm}%
    \setlength{\midchapskip}{\paperwidth}%
    \addtolength{\midchapskip}{-\textwidth}%
    \addtolength{\midchapskip}{-\spinemargin}%
    \renewcommand*{\chapnamefont}{\sffamily\LARGE\flushright}%
    \renewcommand*{\chapnumfont}{\sffamily\HUGE}%
    \renewcommand*{\chaptitlefont}{\sffamily\HUGE\flushright}%
    % Output Routines
    \renewcommand*\printchaptertitle{\chaptitlefont}%
    \renewcommand*\printchapternonum{\AT@bottomscreen}%
    % What comes between chaptername and the number:
    \renewcommand*{\chapternamenum}{}%
    % Print chapter number etc.
    \renewcommand*{\printchapternum}{%
        \setlength{\edgewidth}{\marginparwidth}%
        \addtolength{\edgewidth}{\marginparsep}%
        \makebox[0pt][l]{%
            \hspace{.8em}%
            \resizebox{!}{\beforechapskip}
                {\chapnumfont\thechapter}%
            \hspace{.8em}%
        }%
   }%
   \makeoddfoot{plain}{}{}{\thepage}
}
\makechapterstyle{alpenspecs}{%
    \AT@chapstylesetup
    \renewcommand*{\printchaptername}{%
        \ifhex\AT@numhexagons{1}{chapter}{chapcol}{dv-7}\fi%
        \AT@bottomscreen%
        \chapnamefont\MakeTextUppercase{\@chapapp}%
    }%
}%
\makechapterstyle{alpenappendix}{%
    \AT@chapstylesetup
    \renewcommand*{\printchaptername}{%
        \ifhex\AT@numhexagons{A}{appendix}{appcol}{ct4}\fi%
        \AT@bottomscreen%
        \chapnamefont\MakeTextUppercase{\@chapapp}%
    }%
}%
\chapterstyle{alpenspecs}
\newcommand*\pacname[1]{\textsf{#1}}
\newcommand*\code[1]{\texttt{#1}}
\newcommand*\athes{\pacname{alpenspecs}}
%% \input{randInts.tex}
\newcommand\wpac[7]{%
    \begin{center}
        \vspace{1em}
        \begin{tabular}{lp{100mm}}
            \textsf{\textsc{Ancestors:}}   & #4 \\
            \textsf{\textsc{Descendants:}} & #5 \\
            \textsf{\textsc{Assignee:}}    & #6 \\
            \textsf{\textsc{Description:}} & #7 \\
        \end{tabular}
    \end{center}
}
\input{alpenspecs/randInts.tex}
