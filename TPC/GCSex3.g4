/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar GCSex3;

@header{
        import java.util.*;
        }

@members{
         //adicionar algo que guarde relacoes e conceitos para depois comparar com os que se encontram nos triplos 
         ArrayList<String> con = new ArrayList <String>();
         ArrayList<String> ind = new ArrayList <String>();
         ArrayList<String> rel = new ArrayList <String>();
         ArrayList<String> dot = new ArrayList <String>();
         
         ArrayList<String> owl = new ArrayList <String>();
         ArrayList<String> con_owl = new ArrayList <String>();
         ArrayList<String> ind_owl = new ArrayList <String>();
         ArrayList<String> rel_owl = new ArrayList <String>();
         ArrayList<String> mat_owl = new ArrayList <String>();
         ArrayList<String> relh_owl = new ArrayList <String>();
         String pal1, pal2, rel1;
         }

ontologia 
@after{   
       owl.add("<Ontology>");
       owl.addAll(con_owl);
       owl.addAll(mat_owl);
       owl.addAll(rel_owl);
       owl.addAll(ind_owl);
       owl.addAll(relh_owl);
       owl.add("</Ontology>");
       
       for (String o : owl) 
                System.out.println(o);
       }
    
        
          : PAL {dot.add("digraph "+$PAL.text+ " {");} conceitos individuos relacoes triplos '.'{dot.add("}"); }
          ;
conceitos : 'conceitos' '{'PAL{con.add($PAL.text); con_owl.add("<Declaration> \n <Class IRI=\"#" + $PAL.text+ "\"/>" + "\n</Declaration>");} 
            ('[material:' PAL ']' {mat_owl.add("<Declaration> \n <DataProperty IRI=\"#material\"/>" + "\n</Declaration>");})? 
            (',' PAL{con.add($PAL.text); con_owl.add("<Declaration> \n <Class IRI=\"#" + $PAL.text+ "\"/>"); con_owl.add("</Declaration>");}
            ('[material:' PAL ']' {mat_owl.add("<Declaration> \n <DataProperty IRI=\"#material\"/>" + "\n</Declaration>");} )?)*'}'
          ;

individuos: 'individuos' '{'txtpal{ind.add($txtpal.texto); ind_owl.add("<Declaration> \n <NamedIndividual IRI=\"#" + $txtpal.texto+ "\"/>" + "\n</Declaration>");} 
            (',' txtpal{ind.add($txtpal.texto); ind_owl.add("<Declaration> \n <NamedIndividual IRI=\"#" + $txtpal.texto+ "\"/>" + "\n</Declaration>");})*'}'
          ;

relacoes : 'relacoes' '{'PAL{rel.add($PAL.text);  rel_owl.add("<Declaration> \n <ObjectProperty IRI=\"#" + $PAL.text+ "\"/>" + "\n</Declaration>");} 
           (',' PAL{rel.add($PAL.text); rel_owl.add("<Declaration> \n <ObjectProperty IRI=\"#" + $PAL.text+ "\"/>" + "\n</Declaration>");})*'}' 
         ;

triplos : 'triplos' '{' frase (';' frase)* '}'
        ;
          
frase :   ligacao (';' ligacao)*
      ;

ligacao 
@after{
        if (rel1.equals("is-a") || rel1.equals("iof") || rel1.equals("pof")){
              if(!(con.contains(pal1)|| ind.contains(pal1))) con.add(pal1);
              if(!(con.contains(pal2)|| ind.contains(pal2))) con.add(pal2);
        }
        else{
             if(!((con.contains(pal1)) || (ind.contains(pal1))) && !((con.contains(pal2) || (ind.contains(pal2)))))
                System.out.println("Foi inserido um conceito/individuo não definido previamente. " + pal1 + " " +pal2);
            }
       dot.add("\""+pal1+"\" -> \""+pal2+"\" [ label = \""+ rel1 +"\" ];");
       if(rel1.equals("is-a")){
          relh_owl.add("<SubClassOf> \n <Class IRI=\"#" + pal1 + "\"/>" + "\n <Class IRI=\"#" + pal2 + "\"/>" + "\n</SubClassOf>");
       }
      }
        : txtpal{
                 pal1 = $txtpal.texto;
                }
          '='relacao{rel1 = $relacao.rel;} '=>'
          txtpal{                       
                 pal2 = $txtpal.texto;
                }
        ;

relacao returns [String rel] 
        : PAL{if(!(rel.contains($PAL.text) || !$PAL.equals("is-a") || !$PAL.equals("iof") || !$PAL.equals("pof")))
             System.out.println("Relação não suportada: "+$PAL.text);
             else $rel = $PAL.text;}
        ;

txtpal returns[String texto, String mat]
       : TXT {$texto = $TXT.text;}
       | PAL {$texto = $PAL.text;} ('[material:' TXT{$mat = $PAL.text;} ']')?
       ;

PAL: [a-zA-Z] [-a-zA-Z_0-9]*;
TXT: [\'] ~[\']* [\'] ;
Sep:('\r'? '\n' | '\t')+ ->skip;