/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar Ex1_2;

@header{
        import java.util.*;
        }

lista returns[int comp, int contaN, float media, int max]
@after{if($lista.comp >= 5 && $lista.comp<=10){
       System.out.println("Comprimento da lista: "+$lista.comp);
       System.out.println("Quantidade de numeros: "+$lista.contaN);
       System.out.println("Media de numeros: "+$lista.media);
       System.out.println("Numero maximo: "+$lista.max);
       }
       else System.out.println("Erro: Tamanho tem de ser entre 5 e 10"); 
       }
      : 'LISTA' elems '.' {
            $lista.comp=$elems.comp;
            $lista.contaN=$elems.contaN;
            $lista.media=(float)$elems.soma/$elems.contaN;
            $lista.max=$elems.max;
            }
      ;

elems returns[int comp, int contaN, int soma, int max]
    
@before{
        $elems.max = Integer.MIN_VALUE;
}
    
      : elem {$elems.comp=1;
              $elems.contaN=$elem.num;
              $elems.soma=$elem.val;
              if($elem.num ==1) $elems.max = $elem.val;
              }
        
        (',' elem {$elems.comp++;
                   $elems.contaN=$elems.contaN+$elem.num;
                   $elems.soma=$elems.soma+$elem.val;
                   if($elem.num ==1 && $elem.val > $elems.max) $elems.max = $elem.val;
                   })* 
      ;

elem  returns[int num, int val, int max]
      : PAL {$elem.num=0;$elem.val=0;}
      | NUM {$elem.num=1;$elem.val=$NUM.int;}
      ;

PAL: [a-zA-Z] [-a-zA-Z_0-9]*;
NUM: '0'..'9'+;
Sep:('\r'? '\n' | '\t')+ ->skip;