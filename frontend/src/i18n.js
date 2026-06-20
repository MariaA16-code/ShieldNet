import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

import en from './locales/en.json';
import ur from './locales/ur.json';
import ar from './locales/ar.json';
import fr from './locales/fr.json';
import es from './locales/es.json';

i18n
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: en },
      ur: { translation: ur },
      ar: { translation: ar },
      fr: { translation: fr },
      es: { translation: es },
    },
    lng: 'en',
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false,
    },
  });
i18n.on('languageChanged', (lng) => {
  const rtlLanguages = ['ur', 'ar'];
  document.documentElement.dir = rtlLanguages.includes(lng) ? 'rtl' : 'ltr';
  document.documentElement.lang = lng;
});
export default i18n;