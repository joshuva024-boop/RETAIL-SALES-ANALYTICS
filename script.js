/* ============================================================================
   RETAIL SALES ANALYTICS — Interactive JavaScript
   - Universal Bidirectional Scroll Pop-Up Animations for ALL Sections
   - Pinned Single-Viewport DAX Formula Parallax Showcase (Scroll Up & Scroll Down)
   ============================================================================ */

document.addEventListener('DOMContentLoaded', function () {

  // --------------------------------------------------------------------------
  // 1. Taskbar Active Link Glow & Animated Underline on Scroll
  // --------------------------------------------------------------------------
  (function initScrollSpy() {
    const navLinks = document.querySelectorAll('.primary-nav a, .mobile-nav a');
    const sections = document.querySelectorAll('section[id], header[id]');

    if (!sections.length || !navLinks.length) return;

    const observerOptions = {
      root: null,
      rootMargin: '-20% 0px -60% 0px',
      threshold: 0
    };

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const activeId = entry.target.getAttribute('id');
          navLinks.forEach((link) => {
            const href = link.getAttribute('href');
            if (href === '#' + activeId) {
              link.classList.add('is-active');
            } else {
              link.classList.remove('is-active');
            }
          });
        }
      });
    }, observerOptions);

    sections.forEach((sec) => observer.observe(sec));
  })();

  // --------------------------------------------------------------------------
  // 2. Mobile Menu Toggle
  // --------------------------------------------------------------------------
  (function initMobileMenu() {
    const navToggle = document.getElementById('navToggle');
    const mobileNav = document.getElementById('primary-nav-mobile');

    if (navToggle && mobileNav) {
      navToggle.addEventListener('click', function () {
        const isOpen = mobileNav.classList.toggle('is-open');
        navToggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
      });

      mobileNav.querySelectorAll('a').forEach((link) => {
        link.addEventListener('click', function () {
          mobileNav.classList.remove('is-open');
          navToggle.setAttribute('aria-expanded', 'false');
        });
      });
    }
  })();

  // --------------------------------------------------------------------------
  // 3. Tab Switching for SQL Code Highlights & Dashboard Mockup Pages
  // --------------------------------------------------------------------------
  (function initSqlTabs() {
    const container = document.querySelector('[data-code-tabs]');
    if (!container) return;
    const tabs = container.querySelectorAll('.code-tab');
    const panels = container.querySelectorAll('.code-panel');

    tabs.forEach((tab) => {
      tab.addEventListener('click', () => {
        const tabKey = tab.getAttribute('data-tab');

        tabs.forEach((t) => {
          const active = t === tab;
          t.classList.toggle('is-active', active);
          t.setAttribute('aria-selected', active ? 'true' : 'false');
        });

        panels.forEach((panel) => {
          const match = panel.id === 'panel-' + tabKey;
          panel.classList.toggle('is-active', match);
          if (match) {
            panel.removeAttribute('hidden');
          } else {
            panel.setAttribute('hidden', '');
          }
        });
      });
    });
  })();

  (function initDashboardTabs() {
    const container = document.querySelector('[data-dash-tabs]');
    if (!container) return;
    const tabs = container.querySelectorAll('.dash-tab');
    const panels = container.querySelectorAll('.dash-page-panel');

    tabs.forEach((tab) => {
      tab.addEventListener('click', () => {
        const pageKey = tab.getAttribute('data-page');

        tabs.forEach((t) => {
          const active = t === tab;
          t.classList.toggle('is-active', active);
          t.setAttribute('aria-selected', active ? 'true' : 'false');
        });

        panels.forEach((panel) => {
          const match = panel.id === 'dash-page-' + pageKey;
          panel.classList.toggle('is-active', match);
          if (match) {
            panel.removeAttribute('hidden');
          } else {
            panel.setAttribute('hidden', '');
          }
        });
      });
    });
  })();

  // --------------------------------------------------------------------------
  // 4. Interactive Executive Overview Department Bar Lines & KPI Filtering
  // --------------------------------------------------------------------------
  (function initDeptBarInteractivity() {
    const deptItems = document.querySelectorAll('#deptBarList .dept-bar-item');
    if (!deptItems.length) return;

    const salesEl = document.getElementById('exec-kpi-sales');
    const profitEl = document.getElementById('exec-kpi-profit');
    const marginEl = document.getElementById('exec-kpi-margin');
    const ordersEl = document.getElementById('exec-kpi-orders');
    const badgeEl = document.getElementById('execChartFilterBadge');

    const barJanS = document.getElementById('bar-jan-s');
    const barJanP = document.getElementById('bar-jan-p');
    const barFebS = document.getElementById('bar-feb-s');
    const barFebP = document.getElementById('bar-feb-p');
    const barMarS = document.getElementById('bar-mar-s');
    const barMarP = document.getElementById('bar-mar-p');
    const barAprS = document.getElementById('bar-apr-s');
    const barAprP = document.getElementById('bar-apr-p');
    const barMayS = document.getElementById('bar-may-s');
    const barMayP = document.getElementById('bar-may-p');

    const deptData = {
      all: { sales: '$4.82M', profit: '$612K', margin: '12.7%', orders: '24,510', label: 'All Departments', bars: [60, 25, 70, 30, 65, 28, 85, 40, 95, 48] },
      tech: { sales: '$1.83M', profit: '$235K', margin: '12.8%', orders: '9,310', label: 'Technology', bars: [75, 32, 80, 35, 70, 29, 90, 42, 98, 50] },
      living: { sales: '$1.25M', profit: '$162K', margin: '13.0%', orders: '6,370', label: 'Home & Living', bars: [50, 20, 65, 26, 60, 24, 75, 32, 85, 38] },
      fashion: { sales: '$867K', profit: '$108K', margin: '12.5%', orders: '4,410', label: 'Apparel & Fashion', bars: [45, 18, 55, 22, 50, 20, 65, 28, 70, 30] },
      other: { sales: '$867K', profit: '$107K', margin: '12.3%', orders: '4,420', label: 'Other Categories', bars: [40, 15, 50, 20, 48, 19, 60, 25, 68, 28] }
    };

    deptItems.forEach((item) => {
      item.addEventListener('click', () => {
        const deptKey = item.getAttribute('data-dept');
        const data = deptData[deptKey] || deptData.all;

        deptItems.forEach((d) => d.classList.toggle('is-active', d === item));

        [salesEl, profitEl, marginEl, ordersEl].forEach((el) => {
          if (el) {
            el.classList.add('kpi-value-pulse');
            setTimeout(() => el.classList.remove('kpi-value-pulse'), 300);
          }
        });

        if (salesEl) salesEl.textContent = data.sales;
        if (profitEl) profitEl.textContent = data.profit;
        if (marginEl) marginEl.textContent = data.margin;
        if (ordersEl) ordersEl.textContent = data.orders;
        if (badgeEl) badgeEl.textContent = 'Filtered by: ' + data.label;

        const b = data.bars;
        if (barJanS) barJanS.style.height = b[0] + '%';
        if (barJanP) barJanP.style.height = b[1] + '%';
        if (barFebS) barFebS.style.height = b[2] + '%';
        if (barFebP) barFebP.style.height = b[3] + '%';
        if (barMarS) barMarS.style.height = b[4] + '%';
        if (barMarP) barMarP.style.height = b[5] + '%';
        if (barAprS) barAprS.style.height = b[6] + '%';
        if (barAprP) barAprP.style.height = b[7] + '%';
        if (barMayS) barMayS.style.height = b[8] + '%';
        if (barMayP) barMayP.style.height = b[9] + '%';
      });
    });
  })();

  // --------------------------------------------------------------------------
  // 5. Interactive Regional Sales Filter Cards (Page 2)
  // --------------------------------------------------------------------------
  (function initRegionalInteractivity() {
    const regionCards = document.querySelectorAll('#regionalFilterRow .region-kpi-card');
    const storeRows = document.querySelectorAll('#regionalStoreBars .h-row');
    const badgeEl = document.getElementById('regionalFilterBadge');

    if (!regionCards.length || !storeRows.length) return;

    regionCards.forEach((card) => {
      card.addEventListener('click', () => {
        const regionKey = card.getAttribute('data-region');

        regionCards.forEach((c) => c.classList.toggle('is-active', c === card));

        storeRows.forEach((row) => {
          const rowRegion = row.getAttribute('data-region');
          if (regionKey === 'all' || rowRegion === regionKey) {
            row.style.display = 'grid';
            row.style.opacity = '1';
          } else {
            row.style.opacity = '0.25';
          }
        });

        if (badgeEl) {
          const labelMap = {
            'all': 'Viewing: All Stores',
            'na-east': 'Filtered by: North America East',
            'na-west': 'Filtered by: North America West',
            'eu-west': 'Filtered by: Europe West'
          };
          badgeEl.textContent = labelMap[regionKey] || 'Viewing: All Stores';
        }
      });
    });
  })();

  // --------------------------------------------------------------------------
  // 6. Data Pipeline Architecture Interactive Step Animation
  // --------------------------------------------------------------------------
  (function initPipelineInteractivity() {
    const steps = document.querySelectorAll('#pipelineFlowchart .flow-step');
    if (!steps.length) return;

    steps.forEach((step) => {
      step.addEventListener('click', () => {
        steps.forEach((s) => s.classList.remove('is-active-step'));
        step.classList.add('is-active-step');
      });
    });
  })();

  // --------------------------------------------------------------------------
  // 7. Power BI Star Schema Interactive Nodes
  // --------------------------------------------------------------------------
  (function initSchemaDiagramInteractivity() {
    const nodes = document.querySelectorAll('#schemaDiagram [data-target-spec]');
    const specCards = document.querySelectorAll('#modelSpecsGrid .spec-card');

    if (!nodes.length) return;

    nodes.forEach((node) => {
      node.addEventListener('click', () => {
        const targetId = node.getAttribute('data-target-spec');

        nodes.forEach((n) => n.classList.toggle('is-active', n === node));

        specCards.forEach((card) => {
          const isMatch = card.id === targetId;
          card.classList.toggle('is-active', isMatch);
          if (isMatch) {
            card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
          }
        });
      });
    });
  })();

  // --------------------------------------------------------------------------
  // 8. Universal Bidirectional Scroll Pop-Up Observer for EVERY Section
  // --------------------------------------------------------------------------
  (function initUniversalScrollReveal() {
    const revealElements = document.querySelectorAll('.reveal-card, .reveal-row, .section-head');
    if (!revealElements.length) return;

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-revealed');
          } else {
            entry.target.classList.remove('is-revealed');
          }
        });
      },
      { threshold: 0.12 }
    );

    revealElements.forEach((el) => observer.observe(el));
  })();

  // --------------------------------------------------------------------------
  // 9. Pinned Single-Viewport DAX Formula Parallax Deck (Scroll Up & Scroll Down)
  // --------------------------------------------------------------------------
  (function initDaxPinnedParallaxDeck() {
    const daxSection = document.getElementById('dax');
    const cards = document.querySelectorAll('#daxStage .dax-card-stage-item');
    const dots = document.querySelectorAll('#daxDots .dax-dot-btn');
    const prevBtn = document.getElementById('daxPrevBtn');
    const nextBtn = document.getElementById('daxNextBtn');

    if (!daxSection || !cards.length) return;

    let currentIndex = 0;

    function setActiveCard(idx) {
      if (idx < 0) idx = 0;
      if (idx >= cards.length) idx = cards.length - 1;
      currentIndex = idx;

      cards.forEach((card, i) => {
        card.classList.remove('is-active', 'is-past');
        if (i === idx) {
          card.classList.add('is-active');
        } else if (i < idx) {
          card.classList.add('is-past');
        }
      });

      dots.forEach((dot, i) => {
        dot.classList.toggle('is-active', i === idx);
      });
    }

    // Scroll-linked pinning progress calculation
    window.addEventListener('scroll', () => {
      const rect = daxSection.getBoundingClientRect();
      const sectionHeight = daxSection.offsetHeight - window.innerHeight;

      if (rect.top <= 0 && rect.bottom >= window.innerHeight) {
        const scrolled = -rect.top;
        const progress = Math.max(0, Math.min(1, scrolled / sectionHeight));
        const targetIdx = Math.min(cards.length - 1, Math.floor(progress * cards.length));

        if (targetIdx !== currentIndex) {
          setActiveCard(targetIdx);
        }
      }
    });

    // Control buttons & dot clicks
    dots.forEach((dot) => {
      dot.addEventListener('click', () => {
        const idx = parseInt(dot.getAttribute('data-index'), 10);
        setActiveCard(idx);
        scrollToDaxCardIndex(idx);
      });
    });

    if (prevBtn) {
      prevBtn.addEventListener('click', () => {
        const idx = Math.max(0, currentIndex - 1);
        setActiveCard(idx);
        scrollToDaxCardIndex(idx);
      });
    }

    if (nextBtn) {
      nextBtn.addEventListener('click', () => {
        const idx = Math.min(cards.length - 1, currentIndex + 1);
        setActiveCard(idx);
        scrollToDaxCardIndex(idx);
      });
    }

    function scrollToDaxCardIndex(idx) {
      const sectionTop = daxSection.offsetTop;
      const sectionHeight = daxSection.offsetHeight - window.innerHeight;
      const targetScroll = sectionTop + (idx / cards.length) * sectionHeight;
      window.scrollTo({ top: targetScroll, behavior: 'smooth' });
    }
  })();

  // --------------------------------------------------------------------------
  // 10. Copy Code Buttons
  // --------------------------------------------------------------------------
  (function initCopyButtons() {
    const copyBtns = document.querySelectorAll('.copy-btn');
    copyBtns.forEach((btn) => {
      btn.addEventListener('click', () => {
        const targetId = btn.getAttribute('data-copy-target');
        const codeEl = document.getElementById(targetId);
        if (!codeEl) return;

        navigator.clipboard.writeText(codeEl.textContent).then(() => {
          const origText = btn.textContent;
          btn.textContent = 'Copied!';
          btn.style.background = 'rgba(16, 185, 129, 0.25)';
          btn.style.color = '#10b981';

          setTimeout(() => {
            btn.textContent = origText;
            btn.style.background = '';
            btn.style.color = '';
          }, 2000);
        });
      });
    });
  })();

});
