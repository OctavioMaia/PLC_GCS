/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar ontoPagelas;

@header{
        import java.util.*;
        import java.io.*;
        }

@members{
         //adicionar algo que guarde relacoes e conceitos para depois comparar com os que se encontram nos triplos 
         List<String> con = new ArrayList <>();
         List<String> ind = new ArrayList <>();
         List<String> rel = new ArrayList <>();
         
         List<String> con_owl = new ArrayList <>();
         List<String> ind_owl = new ArrayList <>();
         List<String> rel_owl = new ArrayList <>();
         List<String> mat_owl = new ArrayList <>();
         List<String> relh_owl = new ArrayList <>();
         List<String> inst_owl = new ArrayList <>();
         List<String> instTrip_owl = new ArrayList <>();
         List<String> instAtrib_owl = new ArrayList <>();
         List<String> triplos_owl = new ArrayList <>();
         List<String> atribCon_owl = new ArrayList <>();
         
         List<String> dot = new ArrayList <>();
         List<String> owl = new ArrayList <>();
         
         List<String> html = new ArrayList <>();
         List<String> ind_html = new ArrayList <>();
         List<String> tit_html = new ArrayList <>();
         List<String> cont_html = new ArrayList <>();
         
         Map<String,List<String>> map = new TreeMap<>();
         List<String> conteudo = new ArrayList<>();
         
         
         String pal1, pal2, rel1;
         Map<String, String> data = new HashMap<>();
         }

ontologia
@after{   
       //OWL
       owl.add("<?xml version=\"1.0\"?>\n" +
               "<!DOCTYPE Ontology[\n" +
               "\t<!ENTITY xsd \"http://www.w3.org/2001/XMLSchema#\">\n" +
               "\t<!ENTITY xml \"http://www.w3.org/XML/1998/namespace\">\n" +
               "\t<!ENTITY rdfs \"http://www.w3.org/2000/01/rdf?schema#\">\n" +
               "\t<!ENTITY rdf \"http://www.w3.org/1999/02/22?rdf?syntax?ns#\">\n" +
               "]>\n");
       owl.add("<Ontology>");
       owl.addAll(con_owl);
       owl.addAll(mat_owl);
       owl.addAll(rel_owl);
       owl.addAll(ind_owl);
       owl.addAll(relh_owl);
       owl.addAll(inst_owl);
       owl.addAll(instTrip_owl);
       owl.addAll(instAtrib_owl);
       owl.addAll(triplos_owl);
       owl.addAll(atribCon_owl);
       owl.add("</Ontology>");
       
       //DOT
       try{
         FileWriter writer = new FileWriter("C:/Users/"+System.getProperty("user.name")+"/Documents/GitHub/PLC_GCS/TP1-Santinhos/output_DOT.dot");
         for(String str: dot) {
             writer.write(str);
         }
         writer.flush();
         writer.close();
         System.out.println("Gravei DOT");
       }catch(Exception e){
         System.out.println("Erro DOT");
       }
       
       //OWL
       try{
         FileWriter writer = new FileWriter("C:/Users/"+System.getProperty("user.name")+"/Documents/GitHub/PLC_GCS/TP1-Santinhos/output_OWL.owl");
         for(String str: owl) {
             writer.write(str);
         }
         writer.flush();
         writer.close();
         System.out.println("Gravei OWL");
       }catch(Exception e){
         System.out.println("Erro OWL");
       }
    
       //HTML
       html.add("<html>\n" +
                    "<head>\n"+
                        "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n"+
                            "<meta charset=\"UTF-8\">\n"+
                                "<body>\n"+
                                     "<table>\n"+
                                        "<tr>\n"+
                                            "<td width=\"30%\" valign=\"top\">\n"+
                                                "<h3><a name=\"indice\"></a>Ind�ce de Pagelas\n"+
                                                "</h3>\n"+
                                                "<ol>\n ");
       html.addAll(ind_html);
       html.add("</ol>\n"+
              "</td>\n"+
              "<td width=\"70%\">");
      
       int i=0;
       for (Map.Entry<String, List<String>> entry : map.entrySet()){
           String str = ind_html.get(i);
           html.add("<hr> \n <h3> <a name=\"id\"></a>"+ str+"</h3>"+"\n<h6> \n[<a href=\"#indice\">Voltar ao indice</a>] \n </h6>");

           for(String s : map.get(str.substring(18,26)))
               html.add(s);
           i++;
       }
      
       html.add("\n</html>");
       
       //HTML Save
       try{
         FileWriter writer = new FileWriter("C:/Users/"+System.getProperty("user.name")+"/Documents/GitHub/PLC_GCS/TP1-Santinhos/pagina.html");
         for(String str: html) {
             writer.write(str);
         }
         writer.flush();
         writer.close();
         System.out.println("Gravei HTML");
       }catch(Exception e){
         System.out.println("Erro HTML");
       }
       
      }
    
        
          : 'Ontologia ' PAL {dot.add("digraph "+$PAL.text+ " {");} conceitos individuos? relacoes triplos '.'{dot.add("}"); }
          ;
conceitos returns [String atrib] 
            : 'conceitos' '{'PAL{if(!con.contains($PAL.text)){
                                    con.add($PAL.text);
                                    con_owl.add("<Declaration> \n <Class IRI=\"#" + $PAL.text+ "\"/>" + "\n</Declaration>");
                                 }else 
                                    System.out.println("Foi inserido um conceito previamente adicionado: "+$PAL.text);
                                 } 
            ('[' atribs ']')?
            (',' PAL{if(!con.contains($PAL.text)){
                        con.add($PAL.text);
                        con_owl.add("<Declaration> \n <Class IRI=\"#" + $PAL.text+ "\"/>");
                        con_owl.add("</Declaration>");
                        }
                     else System.out.println("Foi inserido um conceito previamente adicionado: "+$PAL.text);
                     }
            ('[' atribs ']' )?)*'}'
          ;


atribs returns [String atrib, String tipo] : PAL {$atrib=$PAL.text;} ':' PAL {$tipo=$PAL.text; data.put($atrib, $tipo); mat_owl.add("<Declaration> \n <DataProperty IRI=\"#"+$atrib+"\"/>" + "\n</Declaration>");} 
            ((',')PAL {$atrib=$PAL.text;} ':' PAL {$tipo=$PAL.text ; data.put($atrib, $tipo); mat_owl.add("<Declaration> \n <DataProperty IRI=\"#"+$atrib+"\"/>" + "\n</Declaration>");})* 
                              ;

individuos: 'individuos' '{'txtpal{if(!ind.contains($txtpal.texto)){
                                        ind.add($txtpal.texto);
                                        ind_owl.add("<Declaration> \n <NamedIndividual IRI=\"#" + $txtpal.texto+ "\"/>" + "\n</Declaration>");
                                   }
                                   else
                                        System.out.println("Foi inserido um individuo previamente adicionado: "+$txtpal.text);
                                   } 
            (',' txtpal{if(!ind.contains($txtpal.texto)){
                            ind.add($txtpal.texto);
                            ind_owl.add("<Declaration> \n <NamedIndividual IRI=\"#" + $txtpal.texto+ "\"/>" + "\n</Declaration>");
                        }
                        else 
                            System.out.println("Foi inserido um individuo previamente adicionado: "+$txtpal.text);
                        })*'}'
          ;

relacoes : 'relacoes' '{'PAL{if(!rel.contains($PAL.text)){
                                rel.add($PAL.text); 
                                rel_owl.add("<Declaration> \n <ObjectProperty IRI=\"#" + $PAL.text+ "\"/>" + "\n</Declaration>");
                             }
                             else 
                                System.out.println("Foi inserida uma rela��o previamente adicionada: "+$PAL.text);
                             } 
           (',' PAL{
                    if(!rel.contains($PAL.text)){
                        rel.add($PAL.text);
                        rel_owl.add("<Declaration> \n <ObjectProperty IRI=\"#" + $PAL.text+ "\"/>" + "\n</Declaration>");
                    }
                    else
                        System.out.println("Foi inserida uma rela��o previamente adicionada: "+$PAL.text);
                    })*'}' 
         ;

triplos : 'triplos' '{' frase (';' frase)* '}'
        ;
          
frase :   ligacao (';' ligacao)*
      ;

ligacao 
@after{
        // Erros de defini��o.
        if(!(rel.contains(rel1) || rel1.equals("is-a") || rel1.equals("iof") || rel1.equals("pof") )) System.out.println("Rela��o n�o definida: "+rel1);
        if(!(con.contains(pal1) || ind.contains(pal1) )) System.out.println("Palavra n�o definida: "+pal1);
        if(!(con.contains(pal2) || ind.contains(pal2) )) System.out.println("Palavra n�o definida: "+pal2);
        
        // Erros de estrutura. 
        if (rel1.equals("is-a")){    
            if(con.contains(pal1)){
               if(!con.contains(pal2)){
                  if(ind.contains(pal2)){
                     System.out.println("Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                     "\"is-a\" s� suporta rela��es conceito-conceito: "+pal2+" � um individuo.\n");       
                  }
                  
               }
            }
            else{
                 if(ind.contains(pal1)){
                     System.out.println("Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                     "\"is-a\" s� suporta rela��es conceito-conceito: "+pal1+" � um individuo.\n");       
                  }
                 if(ind.contains(pal2)){
                     System.out.println("Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                     "\"is-a\" s� suporta rela��es conceito-conceito: "+pal1+" e "+pal2+" s�o individuos.\n");       
                  }
            }
        }
        else{
             if(rel1.equals("iof")){
                if(ind.contains(pal1)){
                    if(!con.contains(pal2)){
                        if(ind.contains(pal2)){
                            System.out.println("Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                            "\"iof\" s� suporta rela��es individuo-conceito: "+pal2+" � um individuo.\n");       
                        }
                        
                    }
                }
                else{
                    if(con.contains(pal1)){
                        if(ind.contains(pal2)){
                            System.out.println("Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                            "\"iof\" s� suporta rela��es individuo-conceito: "+pal1+" � um conceito e "+pal2+" � um individuo.\n");       
                        }
                        else  System.out.println("Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                              "\"iof\" s� suporta rela��es individuo-conceito: "+pal1+" � um conceito.\n");       
                    }
                    
                }                         
             }
             else{
                  if(rel1.equals("pof")||rel.contains(rel1)){
                     if(con.contains(pal1)){
                        if(!con.contains(pal2)){
                           if(ind.contains(pal2)) 
                              System.out.println( "Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                              rel1 + " s� suporta rela��es entre elementos do mesmo tipo: "+pal2+" � um individuo.\n");
                           
                        }
                     }
                     else{
                         if(ind.contains(pal1)){
                            if(!ind.contains(pal2)){
                                if(con.contains(pal2)) 
                                    System.out.println("Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                                    rel1 + " s� suporta rela��es entre elementos do mesmo tipo: "+pal2+" � um conceito.\n");
                                
                            }                    
                         }
                         
                     }
                  }
                 
             }
        }
        if(dot.contains("\""+pal1+"\" -> \""+pal2+"\" [ label = \""+ rel1 +"\" ];")){
           System.out.println("Erro em: "+pal1+" = "+rel1+" => "+ pal2+"\n"+
                                    "Este triplo j� foi adicionado.\n");                                                                          
        }
        
       dot.add("\""+pal1+"\" -> \""+pal2+"\" [ label = \""+ rel1 +"\" ];");
       if(rel1.equals("is-a")){
          relh_owl.add("<SubClassOf> \n <Class IRI=\"#" + pal1 + "\"/>" + "\n <Class IRI=\"#" + pal2 + "\"/>" + "\n</SubClassOf>");
       }
       if(rel1.equals("iof")){
          inst_owl.add("<ClassAssertion> \n <Class IRI=\"#" + pal1 + "\"/>" + "\n <NamedIndividual IRI=\"#" + pal2 + "\"/>" + "\n</ClassAssertion>");
       }
       if(rel1.equals("owns")| rel1.equals("has") | rel1.equals("pof")){
          instTrip_owl.add("<ObjectPropertyAssertion> \n <ObjectProperty IRI=\"#" + rel1 + "\"/>" + "\n <NamedIndividual IRI=\"#" + pal1 + "\"/>" + "\n <NamedIndividual IRI=\"#" + pal2 + "\"/>"+ "\n</ObjectPropertyAssertion>");
          triplos_owl.add("<ObjectPropertyDomain> \n <ObjectProperty IRI=\"#" + rel1 + "\"/>" + "\n <Class IRI=\"#" + pal1 + "\"/>" + "\n</ObjectPropertyDomain>");
          triplos_owl.add("<ObjectPropertyRange> \n <ObjectProperty IRI=\"#" + rel1 + "\"/>" + "\n <Class IRI=\"#" + pal2 + "\"/>" + "\n</ObjectPropertyRange>");          
       }
       
       //Indice do html
       if(pal1.startsWith("pag") && rel1.equals("iof") &&pal2.startsWith("Pagela")){
       ind_html.add("<li><a href=\"#id\">" + pal1+ "</a></li>"); 
       tit_html.add("<hr> \n <h3> <a name=\"id\"></a>"+ pal1+"</h3>"+
       "\n<h6> \n[<a href=\"#indice\">Voltar ao indice</a>] \n </h6>");
       
       }
       
}        : txtpal{
                 pal1 = $txtpal.texto;
                }
          '='relacao{rel1 = $relacao.rel;} '=>'
          txtpal{                       
                 pal2 = $txtpal.texto;
                }
        ;

relacao returns [String rel] 
        : PAL{if(!(rel.contains($PAL.text) || !$PAL.equals("is-a") || !$PAL.equals("iof") || !$PAL.equals("pof")))
             System.out.println("Rela��o n�o suportada: "+$PAL.text);
             else $rel = $PAL.text;}
        ;

txtpal returns[String texto, String atrib, String tipo]   
    
    : TXT {$texto = $TXT.text;} ('['+PAL {$atrib=$PAL.text;} '=' TXT{$tipo = $TXT.text;
                                                                         instAtrib_owl.add("<DataPropertyAssertion> \n <DataProperty IRI=\"#" + $atrib + "\"/>" + "\n <NamedIndividual IRI=\"#" + pal1 + "\"/> \n <Literal datatypeIRI=\"&xsd;" + data.get($atrib) + "\">"+ $tipo.replace("\"","") + "</Literal> \n</DataPropertyAssertion>");
                                                                         atribCon_owl.add("<DataPropertyDomain> \n <DataProperty IRI=\"#" + $atrib + "\"/>" + "\n <Class IRI=\"#" + $texto + "\"/> \n </DataPropertyDomain> \n <DataPropertyRange> \n <DataProperty IRI=\"#" + $atrib+ "\"/> \n <Datatype abbreviatedIRI=\"xsd:" +data.get($atrib) +  "\"/> \n</DataPropertyRange>");
                                                                         cont_html.add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                         if(pal1.startsWith("pag")){
                                                                            System.out.println("entrei");
                                                                            
                                                                            if(map.containsKey(pal1)){
                                                                                map.get(pal1).add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                            }else{
                                                                                List<String> str = new ArrayList<>();
                                                                                str.add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                                map.put(pal1,str);
                                                                             }
                                                                         }else
                                                                               System.out.println(pal1);
                                                                         }
                                    
                                    ( ',' +PAL {$atrib=$PAL.text;} '=' TXT{$tipo = $TXT.text;
                                                                           instAtrib_owl.add("<DataPropertyAssertion> \n <DataProperty IRI=\"#" + $atrib + "\"/>" + "\n <NamedIndividual IRI=\"#" + pal1 + "\"/> \n <Literal datatypeIRI=\"&xsd;" +data.get($atrib) +  "\">"+ $tipo.replace("\"","") + "</Literal> \n</DataPropertyAssertion>");
                                                                           atribCon_owl.add("<DataPropertyDomain> \n <DataProperty IRI=\"#" + $atrib + "\"/>" + "\n <Class IRI=\"#" + $texto + "\"/> \n </DataPropertyDomain> \n <DataPropertyRange> \n <DataProperty IRI=\"#" + $atrib+ "\"/> \n <Datatype abbreviatedIRI=\"xsd:" +data.get($atrib) +  "\"/> \n</DataPropertyRange>");
                                                                           cont_html.add("<p><b>"+$atrib+":  </b>" +$tipo.replace("\"","")+"\n </p>");
                                                                           if(pal1.startsWith("pag")){
                                                                            System.out.println("entrei");
                                                                            
                                                                            if(map.containsKey(pal1)){
                                                                                map.get(pal1).add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                            }else{
                                                                                List<String> str = new ArrayList<>();
                                                                                str.add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                                map.put(pal1,str);
                                                                             }
                                                                           }else
                                                                               System.out.println(pal1);
                                                                           })* ']')?
      
       
       | PAL {$texto = $PAL.text;} ('['+PAL {$atrib=$PAL.text;} '=' TXT{$tipo = $TXT.text;
                                                                        instAtrib_owl.add("<DataPropertyAssertion> \n <DataProperty IRI=\"#" + $atrib + "\"/>" + "\n <NamedIndividual IRI=\"#" + pal1 + "\"/> \n <Literal datatypeIRI=\"&xsd;" +data.get($atrib) +  "\">"+ $tipo.replace("\"","") + "</Literal> \n</DataPropertyAssertion>");
                                                                        atribCon_owl.add("<DataPropertyDomain> \n <DataProperty IRI=\"#" + $atrib + "\"/>" + "\n <Class IRI=\"#" + $texto + "\"/> \n </DataPropertyDomain> \n <DataPropertyRange> \n <DataProperty IRI=\"#" + $atrib+ "\"/> \n <Datatype abbreviatedIRI=\"xsd:" +data.get($atrib) +  "\"/> \n</DataPropertyRange>");
                                                                        cont_html.add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                        if(pal1.startsWith("pag")){
                                                                            System.out.println("entrei");
                                                                            
                                                                            if(map.containsKey(pal1)){
                                                                                map.get(pal1).add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                            }else{
                                                                                List<String> str = new ArrayList<>();
                                                                                str.add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                                map.put(pal1,str);
                                                                             }
                                                                         }else
                                                                               System.out.println($texto);}
                                    ( ',' +PAL {$atrib=$PAL.text;} '=' TXT{$tipo = $TXT.text;
                                                                           instAtrib_owl.add("<DataPropertyAssertion> \n <DataProperty IRI=\"#" + $atrib + "\"/>" + "\n <NamedIndividual IRI=\"#" + pal1 + "\"/> \n <Literal datatypeIRI=\"&xsd;" +data.get($atrib) +  "\">"+ $tipo.replace("\"","") + "</Literal> \n</DataPropertyAssertion>");
                                                                           atribCon_owl.add("<DataPropertyDomain> \n <DataProperty IRI=\"#" + $atrib + "\"/>" + "\n <Class IRI=\"#" + $texto + "\"/> \n </DataPropertyDomain> \n <DataPropertyRange> \n <DataProperty IRI=\"#" + $atrib+ "\"/> \n <Datatype abbreviatedIRI=\"xsd:" +data.get($atrib) +  "\"/> \n</DataPropertyRange>");
                                                                           cont_html.add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                           if(pal1.startsWith("pag")){
                                                                            System.out.println("entrei");
                                                                            
                                                                            if(map.containsKey(pal1)){
                                                                                map.get(pal1).add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                            }else{
                                                                                List<String> str = new ArrayList<>();
                                                                                str.add("<p><b>"+$atrib+":  </b>" + $tipo.replace("\"","")+"\n </p>");
                                                                                map.put($texto,str);
                                                                             }
                                                                         }else
                                                                               System.out.println($texto);})* ']')?
       ;

PAL: [a-zA-Z] [-a-zA-Z_0-9]*;
TXT: [\'] ~[\']* [\'] 
   | [\"] ~[\"]* [\"]
   ;
Sep:('\r'? '\n' | '\t' | ' ')+ ->skip;
Comment:'%%'~('\n')*'\n' ->skip;