/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar TPC1;

@header{
        import java.util.*;
        }

@members{
         int avaliacao=0;
         }

turma returns[int numAlunos, float media]
@after{if (avaliacao==0){
          System.out.println("Total de alunos: " + $turma.numAlunos);
          
          }
      }
    : 'Turma' PAL alunos{$turma.numAlunos=$alunos.numAlunos;} '.'
    ;

alunos returns[int numAlunos, float media]

       : aluno {$alunos.numAlunos=1;}
         (';' aluno{$alunos.numAlunos+=1;})*
       ;

aluno returns[String nome, float media]
    @after{if (avaliacao==0){
            System.out.println( $aluno.nome+": "+$aluno.media);}}
    
        : PAL '('notas')'{
                          if($notas.numNotas<4 || $notas.numNotas>6) {
                                                                      avaliacao=1;
                                                                      System.out.println("Numero de notas invalido.");
                                                                     }
                          $aluno.nome=$PAL.text;
                          $aluno.media=(float)$notas.sum/$notas.numNotas;
                          }
        ;

notas returns[int numNotas, int sum]
      : AVAL { if($AVAL.int>20 || $AVAL.int < 0) {
                                                  avaliacao=1;
                                                  System.out.println("Nota invalida.");
                                                 }
              $notas.numNotas=1; $notas.sum=$AVAL.int;
             }
        (',' AVAL { if($AVAL.int>20 ||$AVAL.int < 0) {
                                                      avaliacao=1;
                                                      System.out.println("Nota invalida.");
                                                     }
                   $notas.numNotas += 1; $notas.sum += $AVAL.int;
                   })*
      ;

PAL: [a-zA-Z] [-a-zA-Z_0-9]*;
AVAL: '0'..'9'+;
SEP: ('\r'? '\n' | '\t')+ ->skip;