/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar Ex1_2e;

@header{
        import java.util.*;
        }

lista returns[int soma]
@after{
       System.out.println("Somatório: "+$lista.soma);
       }
       
      : 'LISTA' elems '.' {
            $lista.soma = $elems.soma;
            }
      ;

elems returns[int soma]    
      : elem {$elems.soma=$elem.val;}
        
        
        (',' elem {$elems.soma=$elems.soma+$elem.val;})*
      ;

elem  returns[int val, int flag]
      : PAL {$elem.val=0; if($elem.text=="start") $elem.flag=1; if($elem.text=="stop") $elem.flag=0;  }
      | NUM {if($elem.flag == 1) $elem.val=$NUM.int;}
      ;

PAL: [a-zA-Z] [-a-zA-Z_0-9]*;
NUM: '0'..'9'+;
Sep:('\r'? '\n' | '\t')+ ->skip;