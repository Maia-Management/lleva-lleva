import Link from "next/link";

interface Section {
  title: string;
  body: string;
}

interface ContentPageProps {
  eyebrow: string;
  title: string;
  intro: string;
  sections: Section[];
}

export default function ContentPage({
  eyebrow,
  title,
  intro,
  sections,
}: ContentPageProps) {
  return (
    <div className="bg-white">
      <section className="border-b border-navy-100 bg-navy-50">
        <div className="max-w-4xl mx-auto px-4 py-12 md:py-16">
          <p className="text-sm font-semibold uppercase tracking-wide text-amber-700 mb-3">
            {eyebrow}
          </p>
          <h1 className="text-3xl md:text-4xl font-extrabold text-navy-900 mb-4">
            {title}
          </h1>
          <p className="text-lg text-navy-600 leading-8">{intro}</p>
        </div>
      </section>
      <section className="max-w-4xl mx-auto px-4 py-10 md:py-14">
        <div className="space-y-8">
          {sections.map((section) => (
            <section key={section.title}>
              <h2 className="text-xl font-bold text-navy-900 mb-3">
                {section.title}
              </h2>
              <p className="text-navy-600 leading-8">{section.body}</p>
            </section>
          ))}
        </div>
        <div className="mt-10 flex flex-col sm:flex-row gap-3">
          <Link
            href="/listings"
            prefetch={false}
            className="inline-flex items-center justify-center rounded-lg bg-amber-700 px-4 py-2 text-sm font-medium text-white shadow-sm transition-colors hover:bg-amber-800"
          >
            Explorar anuncios
          </Link>
          <Link
            href="/"
            className="inline-flex items-center justify-center rounded-lg border-2 border-navy-200 px-4 py-2 text-sm font-medium text-navy-800 transition-colors hover:bg-navy-50"
          >
            Volver al inicio
          </Link>
        </div>
      </section>
    </div>
  );
}
