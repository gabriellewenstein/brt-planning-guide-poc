package format;

/*
	The AST, as generated by the parsing phase.

	At this stage, all the input has been consumed and validated lexally
	and syntactically, and all commands have been executed.

	However, label matching and validation has not been performed yet, nor
	have the sections been numbered.

	Expr<Def> will be transformed into Expr<GenDef> before being consumed
	by the output routines – namely, the Html and TeX generators.  This is
	the responsibility of the consolidation routines.
*/

/*
	A source file position for an Expr.
*/
typedef Pos = {
	fileName : String,  // should be either relative to the root file, or absolute; relative names are preferred
	lineNumber : Int  // starts at 1
}

/*
	A vertical or horizontal Expr.
*/
typedef Expr<Def> = {
	expr : Def,
	pos : Pos
}

/*
	A horizontal expression definition.

	Expr<HDef> are used to insert some form of continuous text or math,
	such as paragraph text, table cell contents, title text, caption text,
	etc.

	Where more than one Expr<HDef> is needed, one can use horizontal lists
	(HList).  For simpler recursive AST traversal, they are themselves
	Expr<HDef> too.
*/
enum HDef {
	HText(text:String);
	HEmph(expr:Expr<HDef>);
	HHighlight(expr:Expr<HDef>);
	// HMath(tex:String);
	HList(list:Array<Expr<HDef>>);
}

// typedef Image = {
// 	path : String,
// 	size : ImageSize,
// 	placement : ImagePlacement
// }

// typedef Table = {
// 	header : Array<Expr<HDef>>,
// 	data : Array<Array<Expr<HDef>>>
// }

/*
	A vertical expression definition.

	Expr<VDef> are used to insert some form of vertical or block element, such as 
	paragraphs, sections, figures, tables, etc.

	As with Expr<VDef>, vertical lists should be built with the VList
	constructor.
*/
enum VDef {
	VPar(par:Expr<HDef>);
	VSection(label:String, name:Expr<HDef>, ?contents:Expr<VDef>);
	// VFig(label:String, caption:Expr<HDef>, copyright:Expr<HDef>, image:Image);
	// VTable(label:String, title:Expr<HDef>, table:Table);
	VList(list:Array<Expr<VDef>>);
}

/*
	The document.

	The document is simply a vertical expression (Expr<VDef>), in most
	cases, it will be a vertical list.
*/
typedef Document = Expr<VDef>;
