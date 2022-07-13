
#' Cria um datavis em formato tabular das medidas de variacao para os Clubes da Série B
#'
#' @param df dataset criado a a partir da funcao baixa_rendas_brasileirao
#' @param variavel variavel  numerica que provem os dados da tabela
#' @param titulo string de texto que compoe o titulo da tabela
#' @param clubem clube mandante
#' @param placarm_tn placar do clube mandante
#' @param placarv_tn placar do clube visitante
#'
#' @return a tibble
#' @export
#'
#' @examples
#' 
cria_tabela_serie_c<- function(df,
                               variavel, clubem,
                               placarm_tn, placarv_tn,
                               titulo = NULL){
  
  df_rendas <- df
  
  df_rendas <- df_rendas %>% 
    dplyr::mutate(vitoria_m = dplyr::case_when(
      {{placarm_tn}} == {{placarv_tn}} ~ .5,
      {{placarm_tn}} > {{placarv_tn}} ~ 1,
      {{placarm_tn}} < {{placarv_tn}} ~ 0)
    ) %>% 
    dplyr::select(clube = {{clubem}}, {{variavel}}, vitoria_m) %>% 
    dplyr::group_by(clube) %>% 
    dplyr::summarise(
      min = min({{variavel}}, na.rm = TRUE),
      "média" = mean({{variavel}}, na.rm = TRUE),
      "D.P." = stats::sd({{variavel}}, na.rm = TRUE),
      max = max({{variavel}}, na.rm = TRUE),
      "distribuição" = list({{variavel}}),
      "aproveitamento mandante" = list(vitoria_m)
    ) 
  
  df_rendas  %>% 
    dplyr::arrange(dplyr::desc("média")) %>% 
    gt::gt(locale = "pt_BR") %>% 
    gtExtras::gt_plt_dist("distribuição", type = "density", line_color = "blue", 
                          fill_color = "lightblue") %>% 
    gtExtras::gt_plt_winloss("aproveitamento mandante", type = "pill") %>% 
    gt::fmt_number(columns = min:max, decimals = 0) %>% 
    gtExtras::gt_theme_538() %>% 
    gt::tab_header(title = gtExtras::add_text_img(text = stringr::str_glue("{titulo} dos Clubes da Série B"),
                                                  url = "https://upload.wikimedia.org/wikipedia/pt/7/70/Campeonato_Brasileiro_S%C3%A9rie_C_logo.png"
    ))
}


