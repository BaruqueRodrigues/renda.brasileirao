
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rendas.brasileirão

Pacote criado para baixar de forma automática as rendas dos times do
brasileirão.

# Formas de usar

O pacote está armazenado nesse repositório do github para instalar
execute a função abaixo.

``` r
devtools::install_github("BaruqueRodrigues/renda.brasileirao")
```

O uso é simples, você deve passar as rodadas que você tem interesse. Por
enquanto o pacote só baixa os valores para o brasileirão de 2022.

A função baixa_rendas_brasileirao() retorna a um dataframe com as
rodadas desejadas.

``` r
rodadas <- 1:15

df_rendas <- rendas.brasileirao::baixa_rendas_brasileirao(n_rodadas = rodadas)

df_rendas
#> # A tibble: 150 × 42
#>    rodadas data  hora  clubem       clubev id_tabela id_clubem id_clubev escudom
#>    <chr>   <chr> <chr> <chr>        <chr>  <chr>     <chr>     <chr>     <chr>  
#>  1 1       09/04 16h30 Fluminense-… Santo… 88416     11        17        /image…
#>  2 1       09/04 19h00 Atlético Go… Flame… 88422     3         10        /image…
#>  3 1       09/04 21h00 Palmeiras-SP Ceará… 88418     1         29        /image…
#>  4 1       10/04 11h00 Coritiba-PR  Goiás… 88424     7         32        /image…
#>  5 1       10/04 16h00 Atlético Mi… Inter… 88415     4         13        /image…
#>  6 1       10/04 16h00 Botafogo-RJ  Corin… 88419     6         2         /image…
#>  7 1       10/04 18h00 Fortaleza-CE Cuiab… 88421     47        45        /image…
#>  8 1       10/04 19h00 São Paulo-SP Athle… 88417     18        25        /image…
#>  9 1       10/04 19h00 Avaí-SC      Améri… 88423     26        22        /image…
#> 10 1       11/04 20h00 Juventude-RS Braga… 88420     92        28        /image…
#> # … with 140 more rows, and 33 more variables: escudov <chr>, pagante <chr>,
#> #   ingresso <chr>, ingresso_vendido <chr>, placarm_tn <chr>, placarv_tn <chr>,
#> #   prorrogacao <chr>, placarm_pr <chr>, placarv_pr <chr>, penaltis <chr>,
#> #   placarm_pe <chr>, placarv_pe <chr>, renda_bruta <chr>,
#> #   renda_liq_sort <chr>, renda_liq <chr>, valor_renda_liq <chr>,
#> #   estadio <chr>, cidade <chr>, id_periodo <chr>, so_por_rodada <chr>,
#> #   pm_abreviacao <chr>, pv_abreviacao <chr>, arbitro_principal <chr>, …
```

A partir do dataset podemos construir algumas visualizações como a da
renda bruta por time.

``` r
df_rendas %>% 
  mutate(renda_bruta = as.numeric(renda_bruta)) %>% 
  ggplot(aes(x= reorder(clubem, -renda_bruta),
             y=renda_bruta))+
  geom_col(fill = "steelblue")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 90),
        plot.title = element_text(hjust = .5))+
  scale_y_continuous(breaks = seq(0, 18000000, 2000000))+
  labs(x= NULL,
       y= "Renda Bruta em Reais",
       title = "Renda Bruta dos Times do Brasileirão 2022 - Rodadas 1 a 15")
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

O número de ingressos vendidos

``` r
df_rendas %>% 
  mutate(pagante = as.numeric(pagante)) %>% 
  ggplot(aes(x= reorder(clubem, -pagante),
             y=pagante))+
  geom_col(fill = "steelblue")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 90),
        plot.title = element_text(hjust = .5))+
  scale_y_continuous(breaks = seq(0, 360000, 30000))+
  labs(x= NULL,
       y= "Número de Pagantes",
       title = "Número de Ingressos Vendidos dos Times do Brasileirão - Rodadas 1 a 15")
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

A média dos ingressos vendidos

``` r
df_rendas %>% 
  mutate(pagante = as.numeric(pagante)) %>% 
  group_by(clubem) %>% 
  summarise(pagante = mean(pagante)) %>% 
  ggplot(aes(x= reorder(clubem, -pagante),
             y=(pagante)))+
  geom_col(fill = "steelblue")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 90),
        plot.title = element_text(hjust = .5))+
  scale_y_continuous(breaks = seq(0, 55000, 5000))+
  labs(x= NULL,
       y= "Média de Ingressos Vendidos",
       title = "Média Ingressos Vendidos dos Times do Brasileirão - Rodadas 1 a 15")
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />
