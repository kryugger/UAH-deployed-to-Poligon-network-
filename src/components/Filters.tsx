import React from "react";

interface FiltersProps {
  filters: Record<string, string>;
  setFilters: (filters: Record<string, string>) => void;
}

export const Filters: React.FC<FiltersProps> = ({ filters, setFilters }) => {
  return (
    <div style={{ display: "flex", gap: "1rem", flexWrap: "wrap", marginBottom: "1rem" }}>
      <select onChange={(e) => setFilters({ ...filters, country: e.target.value })}>
        <option value="">🌍 Страна</option>
        <option value="Germany">Germany</option>
        <option value="USA">USA</option>
        <option value="India">India</option>
        <option value="Ukraine">Ukraine</option>
      </select>

      <select onChange={(e) => setFilters({ ...filters, ageGroup: e.target.value })}>
        <option value="">📅 Возраст</option>
        <option value="18-24">18–24</option>
        <option value="25-34">25–34</option>
        <option value="35-44">35–44</option>
        <option value="45-54">45–54</option>
        <option value="55-64">55–64</option>
        <option value="65+">65+</option>
      </select>

      <select onChange={(e) => setFilters({ ...filters, gender: e.target.value })}>
        <option value="">🧑 Пол</option>
        <option value="Male">Мужской</option>
        <option value="Female">Женский</option>
        <option value="Other">Другое</option>
      </select>

      <select onChange={(e) => setFilters({ ...filters, ideology: e.target.value })}>
        <option value="">🧠 Убеждения</option>
        <option value="Liberal">Либеральные</option>
        <option value="Conservative">Консервативные</option>
        <option value="Neutral">Нейтральные</option>
      </select>

      <select onChange={(e) => setFilters({ ...filters, religion: e.target.value })}>
        <option value="">🕊️ Религия</option>
        <option value="Christianity">Христианство</option>
        <option value="Islam">Ислам</option>
        <option value="Judaism">Иудаизм</option>
        <option value="Buddhism">Буддизм</option>
        <option value="None">Нет</option>
      </select>
    </div>
  );
};