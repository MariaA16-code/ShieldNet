import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import './Help.css';

function Help() {
  const { t } = useTranslation();
  const [openIndex, setOpenIndex] = useState(null);
  const faqs = t('help.faqs', { returnObjects: true });

  const toggleFaq = (index) => {
    setOpenIndex((prev) => (prev === index ? null : index));
  };

  return (
    <div className="page-container">
      <Navbar />
      <div className="help-page">
        <div className="help-bg" aria-hidden="true">
          <span className="help-blob h1"></span>
          <span className="help-blob h2"></span>
        </div>

        <div className="help-header">
          <span className="eyebrow">{t('help.eyebrow')}</span>
          <h1>{t('help.title')}</h1>
          <p className="help-sub">{t('help.subtitle')}</p>
        </div>

        <div className="faq-list">
          {faqs.map((faq, index) => (
            <div
              key={index}
              className={`faq-item ${openIndex === index ? 'open' : ''}`}
            >
              <button
                className="faq-question"
                onClick={() => toggleFaq(index)}
                aria-expanded={openIndex === index}
              >
                <span>{faq.question}</span>
                <span className="faq-icon">{openIndex === index ? '−' : '+'}</span>
              </button>
              {openIndex === index && (
                <p className="faq-answer">{faq.answer}</p>
              )}
            </div>
          ))}
        </div>

        <div className="help-contact-card">
          <h3>{t('help.stillStuck')}</h3>
          <p>{t('help.contactText')}</p>
          <a href="mailto:zainabb2483@gmail.com" className="btn-primary help-contact-btn">
            {t('help.emailUs')}
          </a>
        </div>
      </div>
      <Footer />
    </div>
  );
}

export default Help;