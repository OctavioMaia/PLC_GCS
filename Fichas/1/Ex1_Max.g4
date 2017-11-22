/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar Ex1_Max;

@header{
        import java.util.*;
        }


lista returns[int comp, int contaN, int sum, float mean, int max]
@after{if($lista.comp==2*($lista.contaN)){
         System.out.println("Comprimento da lista: "+$lista.comp);
         System.out.println("Quantidade de numeros da lista: "+$lista.contaN);
         System.out.println("Sumatorio dos numeros da lista: "+$lista.sum);
         System.out.println("Media dos numeros da lista: "+$lista.mean);
         }
         else{System.out.println("Erro semantico: Numero de palavras diferente do numero de numeros!");
         if($lista.contaN>1){System.out.println("Maior numero da lista: "+$lista.max);} 
        }
       }
      : 'LISTA' elems '.'
        {$lista.comp=$elems.comp;$lista.contaN=$elems.contaN;$lista.sum=$elems.sum;
         $lista.mean=(float)$elems.sum/$elems.contaN;
         $lista.max=$elems.max;}
      ;

elems returns[int comp, int contaN, int sum, int max]
      : elem[Integer.MIN_VALUE]
             {$elems.comp=1;
              $elems.contaN=$elem.num;
              $elems.sum=$elem.val;
              $elems.max=$elem.max;}
        (',' elem[$elems.max] 
                  {$elems.comp++;
                   $elems.contaN=$elems.contaN+$elem.num;
                   $elems.sum=$elems.sum+$elem.val;
                   {$elems.max=$elem.max;}})* 
      ;

elem  [int maxAnt]
      returns[int num, int val, int max]
      : PAL {$elem.num=0; $elem.val=0;
             $elem.max = $elem.maxAnt;}
      | NUM {$elem.num=1;
             $elem.val=$NUM.int;
             if($NUM.int >$elem.maxAnt){$elem.max=$NUM.int;}else{$elem.max=$elem.maxAnt;}}
      ;

PAL: [a-zA-Z] [-a-zA-Z_0-9]*;
NUM: '0'..'9'+;
Sep:('\r'? '\n' | '\t')+ ->skip;