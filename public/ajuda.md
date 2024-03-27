## Introdução {#introducao}

Lapidar é uma aplicação de gerenciamento de dados clínicos.
Nela é possível cadastrar
[pessoas](#cadastros),
[profissionais](#profissionais),
[usuários](#usuarios),
[acompanhamentos profissionais](#acompanhamentos),
[atendimentos](#atendimentos),
[transações financeiras](#financeiro),
[devolutivas](#devolutivas),
anamneses --- [infantojuvenis](#anamneses-infantojuvenis) e [adultas](#anamneses-adultas),
gerar modelos de documentos
e gerenciar a [biblioteca](#biblioteca) da clínica.
Outras funções ainda estão em desenvolvimento
e podem ser verificadas
[na página do Github do projeto](https://github.com/kalebye2/lapidar_rails).

Há dois modos de utilizar a aplicação: o modo visitante e o modo profissional.

Modo Visitante
: A pessoa pode verificar a agenda de hoje da clínica,
bem como verificar os profissionais da clínica e pegar suas informações
de contato.
Ela também pode ver o catálogo na [biblioteca](#biblioteca) da clínica
caso tenha interesse em ler algum material disponível.

Modo Profissional
: A pessoa terá funções dentro da aplicação de acordo com o papel atribuído a ela,
podendo ser
[administrador](#administrador),
[corpo clínico](#corpo-clínico),
[secretário](#secretário),
[financeiro](#papel-financeiro)
e [suporte de TI](#suporte-de-ti).
Cada um desses papéis será melhor detalhado na seção
[Papéis](#papeis)

## Papéis {#papeis}

### Administrador

É o que tem o maior acesso na aplicação.
Todas as funções atribuídas aos outros papéis são atribuídas a ele.
Deve ser utilizado somente por quem, de fato, precisa ter acesso a
todas as funcionalidades da aplicação.
Caso a pessoa seja responsável apenas pela administração da parte técnica
é melhor ser atribuído o papel [Suporte de TI](#suporte-de-ti),
que é limitado a estas questões.

### Corpo Clínico {#corpo-clinico}

Para quem faz parte do corpo clínico.
É capaz de
fazer cadastros,
gerenciar seus acompanhamentos e atendimentos,
fazer gerenciamento de sua parte financeira,
acessar e preparar laudos e anamneses
e escrever suas próprias devolutivas.
O acesso à edição e criação de todas estas partes é limitada
ao que o usuário possui e ele não pode editar ou criar
nada para outro usuário.

### Secretaria

O secretário possui acesso a todos os itens da agenda
de todos os profissionais cadastrados.
Limitado ao gerenciamento de agenda e cadastros na aplicação.

### Financeiro {#papel-financeiro}

O usuário com este papel terá acesso a todos os registros
financeiros dentro da aplicação para criação, edição ou exclusão.

### Suporte de TI

O suporte de TI é o papel para aqueles que terão acesso
às partes técnicas da aplicação.
Eles terão acesso aos dados de acompanhamentos, atendimentos e cadastros,
mas não poderão criar, editar ou excluir nenhum desses registros.
No entanto, partes mais técnicas da aplicação
como registro das diferentes informações secundárias
(ver seção [informações secundárias](#informacoes-secundarias))
e ajuste de dados ou informações dos usuários da aplicação.

## Cadastros

Os cadastros são os registros de todos aqueles que passam pela clínica ---
usuários dos serviços e prestadores de serviços.
Na criação ou edição dos cadastros são solicitados os dados pessoais,
que serão utilizados por toda a aplicação.
O cadastro é a unidade mínima de registro,
pois é necessário para qualquer outro registro existente na plataforma
exceto os da [Biblioteca](#biblioteca).

Quando se escolhe um cadastro, o sistema puxa todos os dados
existentes daquele cadastro para visualização ---
dados pessoais, prontuário, anamneses e laudos.
Se o cadastro também pertencer a um profissional
será possível verificar todos os casos pelos quais é responsável.

## Profissionais

Assim que for registrado o cadastro,
é possível registrar um profissional na plataforma que atenda ao cadastro realizado.
Nesta página é possível
Na página do profissional estarão disponíveis todos os
atendimentos futuros e acompanhamentos pelos quais responde.

### Profissionais usuários da aplicação

Cada vez que um profissional é registrado
é possível que ele tenha um usuário cadastrado
para acessar os dados da aplicação.
Esta é uma funcionalidade específica para profissionais cadastrados
por motivo de segurança
e podem ser alterados em futuras atualizações da aplicação.
O usuário é criado por um [administrador](#administrador) da aplicação
ou um [suporte de TI](#suporte-de-ti).

## Acompanhamentos

Nesta seção é possível ver todos os acompanhamentos profissionais ---
tanto os que estão em curso quando os finalizados ---
com as informações principais sobre seu andamento,
qual o tipo de acompanhamento e profissional responsável,
quando foi o início etc.
Nele também é possível verificar os dados
dos atendimentos dele, bem como baixar um prontuário em formato Markdown
caso o usuário seja do [corpo clínico](#corpo-clinico) e responsável pelo caso
ou da [secretaria](#secretaria).

## Financeiro

Nesta parte o acesso é permitido apenas para quem tem acesso
financeiro na clínica --- perfis administradores e financeiros.
Nela é possível acessar os dados para
[valores de atendimentos](#valores-de-atendimentos),
[recebimentos](#recebimentos),
[gastos](#gastos),
[repasses](#repasses) e
[reajustes](#reajustes) realizados pelos profissionais.

Para toda operação financeira é possível
baixar relatórios nos formatos
CSV e Excel, que são formatos bastante utilizados
por departamentos financeiros e facilitam
alguns registros e análises por parte de economistas
e contadores.

### Valores de atendimentos

Aqui o profissional tem acesso aos valores
de cada atendimento realizado na clínica.
Se for um profissional responsável pelo
[financeiro](#financeiro)
o acesso é liberado para todas as operações
financeiras registradas na aplicação;
caso seja do [corpo clínico](#corpo-clinico) terá acesso apenas
às operações que acompanha.

### Recebimentos

Registro dos valores recebidos na clínica.
Estes registros *não* substituem o registro fiscal
que a clínica fica responsável por realizar normalmente,
é apenas um registro para controle interno.
São registros que *auxiliam* a clínica na elaboração
de documentos fiscais como *recibos*,
que podem ser baixados para cada um dos recebimentos registrados
nos formatos [Markdown](#markdown) e PDF.

### Gastos

IMPLEMENTE.

### Repasses

Aqui são registrados os repasses que a clínica faz aos profissionais.
Quando um recebimento é registrado com a opção
*direto para o profissional* assinalada automaticamente se registra
um repasse ao profissional daquele acompanhamento.
Assim a clínica pode declarar o valor repassado ao profissional
caso tenha um sistema unificado de recebimentos
ou necessite informar a outrem sobre os repasses que realiza,
bem como facilitar o acesso à informação financeira
da clínica.

### Reajustes

## Documentos

Nesta parte os profissionais podem
elaborar os documentos importantes para uso na aplicação como
[laudos](#laudos),
[devolutivas](#devolutivas),
[anamneses](#anamneses) e
[modelos de contrato](#modelos-de-contrato).

É importante ressaltar que os documentos aqui registrados
*não substituem nenhum dos documentos oficiais dos profissionais*
e esta parte está aqui para melhor *compartilhamento* dos mesmos
entre os integrantes da clínica.
Mesmo se permitíssemos um sistema de assinatura digital
ainda assim é necessário que o profissional
faça o seu documento dentro dos padrões estabelecidos.
Eles ficam aqui registrados para melhorar a pesquisa
e facilitar o acesso de outros profissionais às informações
relatadas pelo profissional a respeito de um determinado paciente.

Exclusivamente nesta parte de documentos
existe um padrão para a inclusão de dados relacionados ao documento
se utilizando de [*templates*](#templates).

### Laudos

O registro de laudos aqui existe para que haja
facilidade na pesquisa de outros profissionais.
*Estes registros não substituem o documento oficial do profissional*.
Eles ficam ali registrados para pesquisa e download
de quem tenha interesse, podendo ser baixados em [Markdown](#markdown) ou PDF
para que o profissional responsável possa elaborar o seu documento oficial.

### Devolutivas

Registro das devolutivas do profissional
aos seus pacientes.

### Anamneses

As anamneses estão separadas em
[anamneses infantojuvens](#anamneses-infantojuvenis)
e [anamneses adultas](#anamneses-adultas).
Aqui o profissional registra uma anamnese
para um dos atendimentos que ele tenha realizado.
O atendimento precisa ter sido registrado
com o tipo *ANAMNESE* para aparecer
na lista de atendimentos de registro.

Quando registrar a anamnese
o profissional pode registrar alguns dados pessoais
do paciente como a *data de nascimento* e o *sexo*.
Outros dados pessoais devem ser registrados na parte de
[cadastros](#cadastros).

#### Anamneses infantojuvenis

As anamneses infantojuvenis podem ser registradas
para atendimentos de anamnese de pacientes
em acompanhamento que foi registrado como infantojuvenil
ou cujo paciente tenha menos de 18 anos.

#### Anamneses adultas

Estas anamneses podem ser registradas
para atendimentos de anamnese de pacientes
cujo acompanhamento não foi registrado como infantojuvenil
ou que tenham 18 anos de idade ou mais.

#### Modelos de contrato

AAAA

### Templates

Os templates são partes que possuem *tokens* específicos
que os permite serem substituídos por informações relacionadas ao documento.

- {% paciente.nome %}

## Markdown

Todas as anotações em textos longos são processadas no formato Markdown,
que é um formato de marcação de texto simples com foco em praticidade.
Caso queira saber mais você pode ver
[este guia básico da Pipz Academy](https://docs.pipz.com/central-de-ajuda/learning-center/guia-basico-de-markdown#open)
ou ver [este guia mais detalhado de Markdown (em inglês)](https://markdownguide.org).
Tem também
[este artigo da Alura explicando como trabalhar com esta linguagem de Markup](https://www.alura.com.br/artigos/como-trabalhar-com-markdown).
Este formato foi escolhido por:

1. Ser de simples formatação e fácil de aprender e usar.
1. É um formato fácil de ser convertido
para formatos mais complexos
utilizando ferramentas de conversão como [Pandoc](https://pandoc.org).
1. Utiliza menos espaço em disco que formatos convencionais
como HTML ou XML enquanto oferece opções
de tornar o texto rico em formatação através da conversão.

É importante se familiarizar com este formato,
bem como é indicado utilizar a ferramenta de conversão
[Pandoc](https://pandoc.org) para os documentos baixados
pela aplicação na versão Markdown como prontuários, anamneses e declarações
e convertê-los no formato que preferir.
[Pandoc](https://pandoc.org) é um conversor universal que pode converter
os arquivos baixados no formato Markdown para
PDF (utilizando [LaTeX](https://www.latex-project.org/) ou [wkhtmltopdf](https://wkhtmltopdf.org/)),
HTML (formato da web),
DOCX,
ODT,
RTF,
EPUB,
Microsoft PowerPoint,
slides Beamer,
Slidy
etc.


Todos os dados que podem ser registrados em texto com possibilidade de parágrafos
seguirão esta convenção.
Inclusive este texto de ajuda foi escrito em Markdown
(você pode clicar [aqui](/ajuda.md) para acessar o conteúdo bruto deste texto)
e convertido dentro da aplicação para o formato de visualização da web.

## Biblioteca
