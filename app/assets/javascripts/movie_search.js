// app/assets/javascripts/movie_search.js

console.log("movie_search.js carregado");

function setStatus(message, kind = "info") {
  const el = document.getElementById("search-status");
  if (!el) return;
  el.textContent = message;
  el.className = `status status--${kind}`;
}

document.addEventListener("turbo:load", () => {
  const searchBtn     = document.getElementById("search-movie-btn");
  const searchInput   = document.getElementById("movie-search-title");
  const titleField    = document.getElementById("movie_title");
  const synopsisField = document.getElementById("movie_synopsis");
  const yearField     = document.getElementById("movie_release_year");
  const durationField = document.getElementById("movie_duration");
  const directorField = document.getElementById("movie_director");

  const found = !!searchBtn;
  console.log("movie_search: botão encontrado?", found);
  if (!searchBtn) return;

  searchBtn.addEventListener("click", async () => {
    console.log("movie_search: clique no botão Buscar dados");
    const title = searchInput?.value?.trim();
    if (!title) {
      setStatus("Por favor, digite um título para buscar.", "error");
      return;
    }

    setStatus("Buscando...", "info");
    searchBtn.disabled = true;
    const original = searchBtn.innerHTML;
    searchBtn.innerHTML = '<span class="spinner"></span> Buscando...';

    // Limpa campos
    if (titleField)    titleField.value = "";
    if (synopsisField) synopsisField.value = "";
    if (yearField)     yearField.value = "";
    if (durationField) durationField.value = "";
    if (directorField) directorField.value = "";

    try {
      const url = `/api/movies/search?title=${encodeURIComponent(title)}`;
      console.log("movie_search: requisitando", url);

      const response = await fetch(url, { headers: { "Accept": "application/json" } });
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `Erro ${response.status}`);
      }

      const data = await response.json();
      console.log("movie_search: resposta", data);

      if (titleField)    titleField.value = title;
      if (synopsisField) synopsisField.value = data.synopsis || "";
      if (yearField)     yearField.value = data.release_year || "";
      if (durationField) durationField.value = data.duration || "";
      if (directorField) directorField.value = data.director || "";

      setStatus("Dados preenchidos com sucesso!", "ok");
    } catch (error) {
      console.error("movie_search: erro ao buscar filme:", error);
      setStatus(`Erro: ${error.message}`, "error");
    } finally {
      searchBtn.disabled = false;
      searchBtn.innerHTML = original;
    }
  });
});
