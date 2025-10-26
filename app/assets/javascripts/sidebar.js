console.log("Arquivo sidebar.js carregado com sucesso!");
document.addEventListener("turbo:load", () => {
    const sidebar = document.querySelector("[data-sidebar]");
    const toggle  = document.querySelector("[data-sidebar-toggle]");
    if(!sidebar || !toggle) return;
  
    const mq = window.matchMedia("(max-width: 720px)");
    const isMobile = () => mq.matches;
  
    const applyInitial = () => {
      if(isMobile()){
        sidebar.classList.remove("sidebar--collapsed","sidebar--open");
      }else{
        sidebar.classList.remove("sidebar--open","sidebar--collapsed");
      }
    };
  
    toggle.addEventListener("click", () => {
      if(isMobile()){
        sidebar.classList.toggle("sidebar--open");
      }else{
        sidebar.classList.toggle("sidebar--collapsed");
      }
    });
  
    mq.addEventListener?.("change", applyInitial);
    applyInitial();
  });
  