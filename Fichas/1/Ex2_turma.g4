    /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar Ex2_turma;

@header{
        import java.util.*;
        }

turma : 'Turma' PAL alunos
      ;

alunos : aluno (';' alunos)*
       ;

aluno : PAL '('notas')'
      ;

notas : NOTA (',' NOTA)*
      ;

PAL: [a-zA-Z] [-a-zA-Z_0-9]*;
NOTA: '0'..'9'+;
Sep:('\r'? '\n' | '\t')+ ->skip;