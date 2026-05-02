export default function Loading() {
  return (
    <div className="min-h-[70vh] flex items-center justify-center">
      <div
        className="w-10 h-10 rounded-full border-4 border-brand-blue border-t-transparent animate-spin"
        aria-label="Cargando…"
        role="status"
      />
    </div>
  );
}
