#' baixa_rendas_brasileirao_b
#'
#' @param n_rodadas vetor com número de rodadas
#' @param ano ano do campeonato
#'
#' @return dataframe com os dados sobre o financiamento das partidas da série B do brasileirão
#' @export
#' @import httr
#' @examples
#' baixa_rendas_brasileirao_b(1:15, 2015)
baixa_rendas_brasileirao_b <- function(n_rodadas, ano){
  
  executa_download <- function(n_rodadas){
    
    dados_ex <- dplyr::tibble(ano_camp = seq(2012, 2022, 1),
                              id_fase = c(2, 404, 665, 1032, 1375,
                                          1639, 1870, 2321, 2585, 2805,
                                          2805))
    
    
    id_fase <- dados_ex %>% 
      dplyr::filter(ano_camp == ano) %>%
      dplyr::pull(id_fase)
    
    
    rodadas <- n_rodadas
    
    url <- "https://www.srgoool.com.br/call"
    
    queryString <- list('ajax' = "get_ranking2")
    
    payload <- paste0("id_fase=",
                      id_fase,
                      "&rodada=",
                      rodadas,
                      "&=&sort=")
    
    encode <- "form"
    
    response <-
      VERB(
        "POST",
        url,
        body = payload,
        add_headers(
          authority = 'www.srgoool.com.br',
          accept_language = 'pt-BR,pt;q=0.9',
          origin = 'https://www.srgoool.com.br',
          referer = stringr::str_glue('https://www.srgoool.com.br/classificacao/Brasileirao/Serie-B/{ano}'),
          user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'),
        query = queryString,
        content_type("application/x-www-form-urlencoded"),
        accept("application/json, text/javascript, */*; q=0.01"),
        set_cookies(`CookiePlacarFixo` = "1,43"),
        encode = encode
      )
    
    conteudo <-content(response, simplifyDataFrame = TRUE)
    
    df_rendas <- conteudo$list 
  }
  
  n_rodadas <- n_rodadas
  
  dados <- n_rodadas %>% 
    purrr::map_dfr(executa_download, .id = "rodadas") %>% 
    tibble::tibble() %>% 
    dplyr::mutate(pagante = as.numeric(pagante),
                  ingresso = as.numeric(ingresso),
                  ingresso_vendido = as.numeric(ingresso_vendido),
                  renda_bruta = as.numeric(renda_bruta),
                  renda_liq_sort = as.numeric(renda_liq_sort),
                  renda_liq = as.numeric(renda_liq),
                  valor_renda_liq = as.numeric(valor_renda_liq),
                  data = paste0(data, "/", ano, sep = "") %>% lubridate::dmy())
  
  dados 
}

