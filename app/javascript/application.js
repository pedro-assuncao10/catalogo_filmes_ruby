import "@hotwired/turbo-rails"
import "controllers"
import "sidebar"

// Utilitário de feedback visual para a área de status
function setStatus(message, kind = "info") {
  const el = document.getElementById("search-status");
  if (!el) return;
  el.textContent = message;
  el.className = `status status--${kind}`;
}

document.addEventListener("turbo:load", () => {
  const searchBtn   = document.getElementById("search-movie-btn");
  const searchInput = document.getElementById("movie-search-title");
  const titleField     = document.getElementById("movie_title");
  const synopsisField  = document.getElementById("movie_synopsis");
  const yearField      = document.getElementById("movie_release_year");
  const durationField  = document.getElementById("movie_duration");
  const directorField  = document.getElementById("movie_director");

  if (!searchBtn) return;

  searchBtn.addEventListener("click", async () => {
    console.log("Botão 'Buscar dados' foi clicado!");
    const title = searchInput?.value?.trim();
    if (!title) {
      setStatus("Por favor, digite um título para buscar.", "error");
      return;
    }

    // Estado de carregando
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
      const response = await fetch(`/api/movies/search?title=${encodeURIComponent(title)}`);
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || "Ocorreu um erro na busca.");
      }

      const data = await response.json();

      if (titleField)    titleField.value = title;
      if (synopsisField) synopsisField.value = data.synopsis || "";
      if (yearField)     yearField.value = data.release_year || "";
      if (durationField) durationField.value = data.duration || "";
      if (directorField) directorField.value = data.director || "";

      setStatus("Dados preenchidos com sucesso!", "ok");
    } catch (error) {
      console.error("Erro ao buscar filme:", error);
      setStatus(`Erro: ${error.message}`, "error");
    } finally {
      searchBtn.disabled = false;
      searchBtn.innerHTML = original;
    }
  });
});
