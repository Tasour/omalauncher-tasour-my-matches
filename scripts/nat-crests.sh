#!/bin/sh
# Ecussons des selections nationales : remplace les drapeaux ESPN
# (countries-500-xxx.png) par les vrais ecussons des federations.
# Sources : footylogos.com, Wikimedia (Turquie), TheSportsDB (petites selections).
# Entree : noms de fichiers en arguments ou sur stdin (TTY vide = tout le cache).
# Sortie : ~/.cache/espn-logos/soccer (128x128) et .../banner (256x256).
set -u
S="$HOME/.cache/espn-logos/soccer"
B="$HOME/.cache/espn-logos/banner"
mkdir -p "$S" "$B" 2>/dev/null || exit 0
command -v magick >/dev/null 2>&1 || exit 0
LCK="$HOME/.cache/espn-logos/.crest.lock"
if command -v flock >/dev/null 2>&1; then
  exec 9>"$LCK" 2>/dev/null || exit 0
  flock -n 9 || exit 0
else
  mkdir "$LCK.d" 2>/dev/null || exit 0
  trap 'rmdir "$LCK.d" 2>/dev/null' EXIT
fi
TMPD="${TMPDIR:-/tmp}/crests.$$"
mkdir -p "$TMPD" 2>/dev/null || exit 0
trap 'rm -rf "$TMPD"' EXIT INT TERM

width() {
  od -An -N4 -j16 -tu1 "$1" 2>/dev/null | awk '{printf "%d", $1*16777216+$2*65536+$3*256+$4}'
}

crest_url() {
  slug=
  case "$1" in
    boe) printf '%s' "https://r2.thesportsdb.com/images/media/team/badge/flwbqo1600954995.png"; return;;
    bvr) printf '%s' "https://r2.thesportsdb.com/images/media/team/badge/1lr4nx1600955147.png"; return;;
    cok) printf '%s' "https://r2.thesportsdb.com/images/media/team/badge/r3nsoz1737953407.png"; return;;
    mac) printf '%s' "https://r2.thesportsdb.com/images/media/team/badge/dj6u171597863545.png"; return;;
    marq) printf '%s' "https://r2.thesportsdb.com/images/media/team/badge/eka0vx1728750119.png"; return;;
    sma) printf '%s' "https://r2.thesportsdb.com/images/media/team/badge/5a2vju1600974345.png"; return;;
    stm) printf '%s' "https://r2.thesportsdb.com/images/media/team/badge/0l8n3j1718413842.png"; return;;
    tah) printf '%s' "https://r2.thesportsdb.com/images/media/team/badge/nfmoqp1600866065.png"; return;;
    10528) slug=central-african-republic;;
    10529) slug=guam;;
    11678) slug=curacao;;
    11766) slug=puerto-rico;;
    11808) slug=sao-tome-and-principe;;
    4214) slug=zimbabwe;;
    5784) slug=bhutan;;
    afg) slug=afghanistan;;
    aia) slug=anguilla;;
    alb) slug=albania;;
    alg) slug=algeria;;
    and) slug=andorra;;
    ang) slug=angola;;
    arg) slug=argentina;;
    aru) slug=aruba;;
    asa) slug=american-samoa;;
    aus) slug=australia;;
    aut) slug=austria;;
    aze) slug=azerbaijan;;
    bah) slug=bahamas;;
    ban) slug=bangladesh;;
    bdi) slug=burundi;;
    bel) slug=belgium;;
    ben) slug=benin;;
    ber) slug=bermuda;;
    bhr) slug=bahrain;;
    bih) slug=bosnia-and-herzegovina;;
    bka) slug=burkina-faso;;
    blr) slug=belarus;;
    blz) slug=belize;;
    bol) slug=bolivia;;
    bot) slug=botswana;;
    bra) slug=brazil;;
    brb) slug=barbados;;
    bul) slug=bulgaria;;
    cam) slug=cambodia;;
    can) slug=canada;;
    cay) slug=cayman-islands;;
    chi) slug=chile;;
    chn) slug=china;;
    civ) slug=cote-d-ivoire;;
    col) slug=colombia;;
    com) slug=comoros;;
    cpv) slug=cabo-verde;;
    crc) slug=costa-rica;;
    crm) slug=cameroon;;
    cro) slug=croatia;;
    cub) slug=cuba;;
    cyp) slug=cyprus;;
    cze) slug=czechia;;
    den) slug=denmark;;
    dji) slug=djibouti;;
    dma) slug=dominica;;
    dom) slug=dominican-republic;;
    ecu) slug=ecuador;;
    egy) slug=egypt;;
    eng) slug=england;;
    eqg) slug=equatorial-guinea;;
    esp) slug=spain;;
    est) slug=estonia;;
    eth) slug=ethiopia;;
    fifa.armenia) slug=armenia;;
    fij) slug=fiji;;
    fin) slug=finland;;
    fra) slug=france;;
    fro) slug=faroe-islands;;
    gab) slug=gabon;;
    gam) slug=gambia;;
    geo) slug=georgia;;
    ger) slug=germany;;
    gha) slug=ghana;;
    gib) slug=gibraltar;;
    gre) slug=greece;;
    grn) slug=grenada;;
    gua) slug=guam;;
    gui) slug=guinea;;
    guy) slug=guyana;;
    hai) slug=haiti;;
    hkg) slug=hong-kong;;
    hon) slug=honduras;;
    hun) slug=hungary;;
    idn) slug=indonesia;;
    ind) slug=india;;
    irl) slug=republic-of-ireland;;
    irn) slug=iran;;
    irq) slug=iraq;;
    isl) slug=iceland;;
    isr) slug=israel;;
    ita) slug=italy;;
    jam) slug=jamaica;;
    jor) slug=jordan;;
    jpn) slug=japan;;
    kaz) slug=kazakhstan;;
    ken) slug=kenya;;
    kgz) slug=kyrgyztan;;
    kors) slug=south-korea;;
    kosovo) slug=kosovo;;
    ksa) slug=saudi-arabia;;
    kuw) slug=kuwait;;
    lbr) slug=liberia;;
    lby) slug=libya;;
    lca) slug=saint-lucia;;
    les) slug=lesotho;;
    lib) slug=lebanon;;
    lie) slug=liechtenstein;;
    ltu) slug=lithuania;;
    lux) slug=luxembourg;;
    lva) slug=latvia;;
    mad) slug=madagascar;;
    mar) slug=morocco;;
    mas) slug=malaysia;;
    mda) slug=moldova;;
    mdv) slug=maldives;;
    mex) slug=mexico;;
    mgl) slug=mongolia;;
    mkd) slug=north-macedonia;;
    mli) slug=mali;;
    mlt) slug=malta;;
    moz) slug=mozambique;;
    mri) slug=mauritius;;
    mtg) slug=montenegro;;
    mtn) slug=mauritania;;
    mwi) slug=malawi;;
    mya) slug=myanmar;;
    nam) slug=namibia;;
    nca) slug=nicaragua;;
    ncd) slug=new-caledonia;;
    ned) slug=netherlands-national-team-dutch;;
    nga) slug=nigeria;;
    nig) slug=niger;;
    nir) slug=northern-ireland;;
    nor) slug=norway;;
    nzl) slug=new-zealand;;
    oma) slug=oman;;
    pak) slug=pakistan;;
    pal) slug=palestine;;
    pan) slug=panama;;
    par) slug=paraguay;;
    per) slug=peru;;
    phi) slug=philippines;;
    png) slug=papua-new-guinea;;
    pol) slug=poland;;
    por) slug=portugal;;
    qat) slug=qatar;;
    rdc) slug=dr-congo;;
    rom) slug=romania;;
    rsa) slug=south-africa;;
    rus) slug=russia;;
    rwa) slug=rwanda;;
    sba) slug=serbia;;
    sco) slug=scotland;;
    sen) slug=senegal;;
    sey) slug=seychelles;;
    sin) slug=singapore;;
    skn) slug=saint-kitts-and-nevis;;
    sle) slug=sierra-leone;;
    slv) slug=el-salvador;;
    smr) slug=san-marino;;
    sol) slug=solomon-islands;;
    sri) slug=sri-lanka;;
    sud) slug=sudan;;
    sui) slug=switzerland;;
    sur) slug=suriname;;
    svk) slug=slovakia;;
    svn) slug=slovenia;;
    swe) slug=sweden;;
    swz) slug=eswatini;;
    syr) slug=syria;;
    tan) slug=tanzania;;
    tha) slug=thailand;;
    tjk) slug=tajikistan;;
    tkm) slug=turkmenistan;;
    tog) slug=togo;;
    tri) slug=trinidad-and-tobago;;
    tun) slug=tunisia;;
    tur) printf '%s' "https://upload.wikimedia.org/wikipedia/en/thumb/7/70/Turkish_Football_Federation_crest.svg/500px-Turkish_Football_Federation_crest.svg.png"; return;;
    uae) slug=united-arab-emirates;;
    uga) slug=uganda;;
    ukr) slug=ukraine;;
    uru) slug=uruguay;;
    usa) slug=usa;;
    uzb) slug=uzbekistan;;
    van) slug=vanuatu;;
    ven) slug=venezuela;;
    vie) slug=vietnam;;
    vin) slug=saint-vincent-and-the-grenadines;;
    vir) slug=us-virgin-islands;;
    wal) slug=wales;;
    yem) slug=yemen;;
    zam) slug=zambia;;
  esac
  [ -n "${slug:-}" ] || return 1
  if [ "$slug" = "netherlands-national-team-dutch" ]; then
    printf 'https://assets.footylogos.com/logos/%s/%s-logo-footylogos.png' "$slug" "$slug"
  else
    printf 'https://assets.footylogos.com/logos/%s-national-team/%s-national-team-logo-footylogos.png' "$slug" "$slug"
  fi
}

sync_one() {
  f=$1
  case "$f" in countries-500-*.png) ;; *) return 0 ;; esac
  code=${f#countries-500-}
  code=${code%.png}
  sw=$(width "$S/$f")
  bw=$(width "$B/$f")
  [ "$sw" = 128 ] && [ "$bw" = 256 ] && return 0
  url=$(crest_url "$code") || return 0
  raw="$TMPD/$code.raw"
  if [ ! -s "$raw" ]; then
    curl --proto '=https' --max-redirs 0 --max-filesize 8388608 --connect-timeout 5 --retry 2 --retry-delay 1 --retry-max-time 30 -fsm 25 -o "$raw" "$url" 2>/dev/null || { rm -f "$raw"; return 1; }
  fi
  if [ "$sw" != 128 ]; then
    if magick "$raw" -background none -gravity center -resize 128x128 -extent 128x128 -strip PNG32:"$TMPD/$code.s.png" 2>/dev/null; then
      mv "$TMPD/$code.s.png" "$S/.$f.$$.tmp" 2>/dev/null && mv "$S/.$f.$$.tmp" "$S/$f"
    fi
  fi
  if [ "$bw" != 256 ]; then
    if magick "$raw" -background none -gravity center -resize 256x256 -extent 256x256 -strip PNG32:"$TMPD/$code.b.png" 2>/dev/null; then
      mv "$TMPD/$code.b.png" "$B/.$f.$$.tmp" 2>/dev/null && mv "$B/.$f.$$.tmp" "$B/$f"
    fi
  fi
}

if [ -t 0 ] && [ "$#" -eq 0 ]; then
  set -- $(ls "$S"/countries-500-*.png 2>/dev/null)
fi
n=0
if [ "$#" -gt 0 ]; then
  for f in "$@"; do
    [ -n "$f" ] || continue
    case "$f" in */*) f=$(basename "$f") ;; esac
    sync_one "$f" &
    n=$((n + 1))
    if [ "$n" -ge 6 ]; then wait; n=0; fi
  done
else
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    case "$f" in */*) f=$(basename "$f") ;; esac
    sync_one "$f" &
    n=$((n + 1))
    if [ "$n" -ge 6 ]; then wait; n=0; fi
  done
fi
wait
exit 0
